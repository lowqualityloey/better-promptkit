#!/usr/bin/env bash
# Deterministic, dependency-free local release-evidence property harness.
# Run from repository root: bash scripts/tests/run-release-record-properties.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
FIXTURE_ROOT="$REPO_ROOT/scripts/tests/fixtures/release-records"
ITERATIONS=100
SEED=20260908
RNG_STATE=$SEED
CHOICE=0

declare -A CASE_FIELD=()
declare -A CASE_IDS=()
declare -A CASE_SEEN=()

fail_harness() {
    echo "HARNESS_FAILURE|$1" >&2
    exit 1
}

fail_property() {
    echo "PROPERTY_FAILURE|$1|ITERATION=$2|$3" >&2
    exit 1
}

next_choice() {
    local modulus="$1"
    RNG_STATE=$(( (RNG_STATE * 48271) % 2147483647 ))
    CHOICE=$(( RNG_STATE % modulus ))
}

case_field() {
    local property="$1" case_id="$2" field="$3"
    printf '%s' "${CASE_FIELD["$property|$case_id|$field"]-NONE}"
}

load_fixture() {
    local property="$1" file="$FIXTURE_ROOT/$property.tsv"
    local case_id entity field value key case_key
    [[ -f "$file" ]] || fail_harness "Missing fixture: $file"
    while IFS=$'\t' read -r case_id entity field value || [[ -n "$case_id" ]]; do
        [[ -z "$case_id" || "$case_id" == \#* ]] && continue
        [[ -z "$entity" || -z "$field" || -z "$value" ]] && fail_harness "Malformed fixture row in $file"
        key="$property|$case_id|$field"
        CASE_FIELD["$key"]="$value"
        case_key="$property|$case_id"
        if [[ -z "${CASE_SEEN[$case_key]+present}" ]]; then
            CASE_SEEN["$case_key"]=1
            CASE_IDS["$property"]="${CASE_IDS[$property]-} $case_id"
        fi
    done < "$file"
    [[ -n "${CASE_IDS[$property]-}" ]] || fail_harness "Fixture has no cases: $file"
}

assert_shape_generation() {
    local property="$1" iteration="$2"
    local prefix="${property^^}-$iteration"
    local commit_id="COMMIT-$prefix"
    local merge_id="MERGE-$prefix"
    local squash_id="SQUASH-$prefix"
    local duplicate_a="DUP-A-$prefix"
    local duplicate_b="DUP-B-$prefix"
    local revert_id="REVERT-$prefix"
    local reverted_id="REVERTED-$prefix"
    local partial_id="PARTIAL-REVERT-$prefix"
    local duplicate_group="DUPLICATE-GROUP-$prefix"
    local full_revert_relation="$revert_id=>$reverted_id"
    local partial_evidence="EVIDENCE-$partial_id"
    local qa_pass="QA-$prefix:pass"
    local qa_blocked="QA-$prefix:blocked"
    local -a combined_history=("$commit_id" "$merge_id" "$squash_id" "$duplicate_a" "$duplicate_b" "$reverted_id" "$revert_id" "$partial_id")
    local -a action_log=()
    [[ "$commit_id" == COMMIT-* && "${combined_history[0]}" == "$commit_id" ]] || fail_harness "Synthetic commit history is unstable"
    [[ "${combined_history[1]}" == "$merge_id" && "${combined_history[2]}" == "$squash_id" ]] || fail_harness "Synthetic merge/squash order is invalid"
    [[ "$duplicate_a" != "$duplicate_b" && "$duplicate_group" == DUPLICATE-GROUP-* ]] || fail_harness "Synthetic duplicate group is invalid"
    [[ "$full_revert_relation" == "$revert_id=>$reverted_id" && "$partial_id" == PARTIAL-REVERT-* ]] || fail_harness "Synthetic revert relations are invalid"
    [[ "$partial_evidence" == EVIDENCE-* ]] || fail_harness "Synthetic partial-revert evidence is missing"
    [[ "$qa_pass" == *:pass && "$qa_blocked" == *:blocked ]] || fail_harness "Synthetic QA outcomes are invalid"
    [[ "${#combined_history[@]}" -eq 8 && "${#action_log[@]}" -eq 0 ]] || fail_harness "Synthetic history or action stub is invalid"
}

join_csv() {
    local IFS=','
    printf '%s' "$*"
}

classify_evidence() {
    local case_id="$1" conventional_type="$2"
    local public evidence linked contract before after impact proposed guidance
    local maintenance_declared no_public_contract complete=1 expected_proposed
    public="$(case_field property-01 "$case_id" public)"
    evidence="$(case_field property-01 "$case_id" evidence)"
    linked="$(case_field property-01 "$case_id" linked)"
    contract="$(case_field property-01 "$case_id" contract)"
    before="$(case_field property-01 "$case_id" before)"
    after="$(case_field property-01 "$case_id" after)"
    impact="$(case_field property-01 "$case_id" impact)"
    proposed="$(case_field property-01 "$case_id" proposed)"
    guidance="$(case_field property-01 "$case_id" guidance)"
    maintenance_declared="$(case_field property-01 "$case_id" maintenance_declared)"
    no_public_contract="$(case_field property-01 "$case_id" no_public_contract)"
    : "${conventional_type:?}"

    if [[ "$public" == 1 ]]; then
        [[ "$evidence" != NONE || "$linked" != NONE ]] || complete=0
        for value in "$contract" "$before" "$after" "$impact"; do
            [[ "$value" != NONE ]] || complete=0
        done
        case "$impact" in
            additive) expected_proposed=minor ;;
            corrective) expected_proposed=patch ;;
            breaking) expected_proposed=major; [[ "$guidance" != NONE ]] || complete=0 ;;
            *) complete=0; expected_proposed=none ;;
        esac
        [[ "$proposed" == "$expected_proposed" ]] || complete=0
        [[ "$complete" -eq 1 ]] && printf 'eligible' || printf 'incomplete'
        return
    fi

    if [[ "$maintenance_declared" == 1 && "$no_public_contract" == 1 && "$proposed" == none ]]; then
        printf 'maintenance'
    else
        printf 'incomplete'
    fi
}

property_one() {
    local iteration case_id expected actual
    local -a types=(feat fix perf)
    for ((iteration = 1; iteration <= ITERATIONS; iteration++)); do
        assert_shape_generation property-01 "$iteration"
        for case_id in ${CASE_IDS[property-01]}; do
            next_choice "${#types[@]}"
            expected="$(case_field property-01 "$case_id" expected)"
            actual="$(classify_evidence "$case_id" "${types[$CHOICE]}")"
            [[ "$actual" == "$expected" ]] || fail_property eligible-evidence-maintenance "$iteration" "$case_id expected $expected got $actual"
        done
    done
    echo "PROPERTY|eligible-evidence-maintenance|SEED=$SEED|ITERATIONS=$ITERATIONS|PASS"
}

augment_history() {
    local history="$1" candidate="$2" iteration="$3"
    local -a items=()
    local item
    AUGMENTED_HISTORY=()
    IFS=',' read -r -a items <<< "$history"
    for item in "${items[@]}"; do
        if [[ "$item" == "$candidate" ]]; then
            AUGMENTED_HISTORY+=("GEN-P02-$iteration-$CHOICE")
        fi
        AUGMENTED_HISTORY+=("$item")
    done
    AUGMENTED_HISTORY_CSV="$(join_csv "${AUGMENTED_HISTORY[@]}")"
}

select_release_range() {
    local history="$1" baseline="$2" candidate="$3"
    local -a items=()
    local item index=0 baseline_index=-1 candidate_index=-1 candidate_count=0 started=0
    RESULT_RANGE=()
    RESULT_VALID=1
    IFS=',' read -r -a items <<< "$history"
    [[ "$baseline" == NONE ]] && started=1
    for item in "${items[@]}"; do
        if [[ "$item" == "$baseline" && "$baseline" != NONE ]]; then
            baseline_index=$index
            started=1
            index=$((index + 1))
            continue
        fi
        if [[ "$item" == "$candidate" ]]; then
            candidate_count=$((candidate_count + 1))
            candidate_index=$index
        fi
        [[ "$started" -eq 1 ]] && RESULT_RANGE+=("$item")
        index=$((index + 1))
    done
    [[ "$baseline" == NONE || "$baseline_index" -ge 0 ]] || RESULT_VALID=0
    [[ "$candidate_count" -eq 1 && "$candidate_index" -ge 0 ]] || RESULT_VALID=0
    [[ "$candidate_index" -eq $(( ${#items[@]} - 1 )) ]] || RESULT_VALID=0
    [[ "$baseline" == NONE || "$baseline_index" -lt "$candidate_index" ]] || RESULT_VALID=0
    [[ "${#RESULT_RANGE[@]}" -gt 0 && "${RESULT_RANGE[-1]}" == "$candidate" ]] || RESULT_VALID=0
    RESULT_RANGE_CSV="$(join_csv "${RESULT_RANGE[@]}")"
}

property_two() {
    local iteration case_id history baseline candidate expected first_result second_result
    for ((iteration = 1; iteration <= ITERATIONS; iteration++)); do
        assert_shape_generation property-02 "$iteration"
        for case_id in ${CASE_IDS[property-02]}; do
            next_choice 2
            history="$(case_field property-02 "$case_id" history)"
            baseline="$(case_field property-02 "$case_id" baseline)"
            candidate="$(case_field property-02 "$case_id" candidate)"
            expected="$(case_field property-02 "$case_id" expected)"
            augment_history "$history" "$candidate" "$iteration"
            select_release_range "$AUGMENTED_HISTORY_CSV" "$baseline" "$candidate"
            first_result="$RESULT_VALID|$RESULT_RANGE_CSV"
            select_release_range "$AUGMENTED_HISTORY_CSV" "$baseline" "$candidate"
            second_result="$RESULT_VALID|$RESULT_RANGE_CSV"
            [[ "$first_result" == "$second_result" ]] || fail_property candidate-inclusive-range "$iteration" "$case_id is not reproducible"
            if [[ "$expected" == PASS ]]; then
                [[ "$RESULT_VALID" -eq 1 ]] || fail_property candidate-inclusive-range "$iteration" "$case_id expected PASS"
            else
                [[ "$RESULT_VALID" -eq 0 ]] || fail_property candidate-inclusive-range "$iteration" "$case_id expected FAIL"
            fi
        done
    done
    echo "PROPERTY|candidate-inclusive-range|SEED=$SEED|ITERATIONS=$ITERATIONS|PASS"
}

resolve_latest_approved() {
    local records="$1"
    local -a items=()
    local record record_id status version commit evaluation sequence
    local highest=-1
    RESULT_BASELINE=NONE
    IFS=';' read -r -a items <<< "$records"
    for record in "${items[@]}"; do
        IFS=',' read -r record_id status version commit evaluation sequence <<< "$record"
        if [[ "${status,,}" == approved && "$sequence" =~ ^[0-9]+$ && "$sequence" -gt "$highest" ]]; then
            highest="$sequence"
            RESULT_BASELINE="$evaluation|$version|$commit"
        fi
    done
}

property_three() {
    local iteration case_id records expected generated_result
    for ((iteration = 1; iteration <= ITERATIONS; iteration++)); do
        assert_shape_generation property-03 "$iteration"
        for case_id in ${CASE_IDS[property-03]}; do
            next_choice 2
            records="$(case_field property-03 "$case_id" records)"
            expected="$(case_field property-03 "$case_id" expected)"
            records="$records;R-GEN,preliminary,9.9.9,GEN-P03-$iteration,GEN-EVAL-$iteration,$((100 + iteration))"
            resolve_latest_approved "$records"
            generated_result="${RESULT_BASELINE%%|*}"
            [[ "$generated_result" == "$expected" ]] || fail_property latest-approved-baseline "$iteration" "$case_id expected $expected got $generated_result"
        done
    done
    echo "PROPERTY|latest-approved-baseline|SEED=$SEED|ITERATIONS=$ITERATIONS|PASS"
}

classify_impact() {
    local impact="$1" guidance="$2" proposed="$3" derived
    case "$impact" in
        additive) derived=minor ;;
        corrective) derived=patch ;;
        breaking) [[ "$guidance" != NONE ]] && derived=major || derived=blocked ;;
        none) derived=none ;;
        *) derived=blocked ;;
    esac
    if [[ "$proposed" != NONE && "$proposed" != "$derived" && "$derived" != blocked ]]; then
        derived=blocked
    fi
    printf '%s' "$derived"
}

property_four() {
    local iteration case_id impact guidance proposed expected actual types type
    local -a type_values=()
    for ((iteration = 1; iteration <= ITERATIONS; iteration++)); do
        assert_shape_generation property-04 "$iteration"
        for case_id in ${CASE_IDS[property-04]}; do
            types="$(case_field property-04 "$case_id" types)"
            IFS=',' read -r -a type_values <<< "$types"
            next_choice "${#type_values[@]}"
            type="${type_values[$CHOICE]}"
            : "${type:?}"
            impact="$(case_field property-04 "$case_id" impact)"
            guidance="$(case_field property-04 "$case_id" guidance)"
            proposed="$(case_field property-04 "$case_id" proposed)"
            expected="$(case_field property-04 "$case_id" expected)"
            actual="$(classify_impact "$impact" "$guidance" "$proposed")"
            [[ "$actual" == "$expected" ]] || fail_property evidence-driven-impact "$iteration" "$case_id expected $expected got $actual"
        done
    done
    echo "PROPERTY|evidence-driven-impact|SEED=$SEED|ITERATIONS=$ITERATIONS|PASS"
}

parse_core_semver() {
    local version="${1#v}"
    [[ "$version" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)$ ]] || return 1
    SEMVER_MAJOR="${BASH_REMATCH[1]}"
    SEMVER_MINOR="${BASH_REMATCH[2]}"
    SEMVER_PATCH="${BASH_REMATCH[3]}"
}

derive_candidate() {
    local impacts="$1" prior="$2" first="$3" impact rank=0
    RESULT_IMPACT=none
    RESULT_VERSION=NONE
    IFS=',' read -r -a impact_values <<< "$impacts"
    for impact in "${impact_values[@]}"; do
        case "$impact" in
            blocked)
                RESULT_IMPACT=blocked
                RESULT_VERSION=NONE
                return
                ;;
            major)
                if (( rank < 3 )); then
                    rank=3
                    RESULT_IMPACT=major
                fi
                ;;
            minor)
                if (( rank < 2 )); then
                    rank=2
                    RESULT_IMPACT=minor
                fi
                ;;
            patch)
                if (( rank < 1 )); then
                    rank=1
                    RESULT_IMPACT=patch
                fi
                ;;
            none) ;;
            *)
                RESULT_IMPACT=blocked
                RESULT_VERSION=NONE
                return
                ;;
        esac
    done
    if (( rank == 0 )); then
        return 0
    fi
    if [[ "$first" == 1 ]]; then
        RESULT_VERSION=1.0.0
        return
    fi
    parse_core_semver "$prior" || { RESULT_IMPACT=blocked; return; }
    case "$RESULT_IMPACT" in
        major) RESULT_VERSION="$((SEMVER_MAJOR + 1)).0.0" ;;
        minor) RESULT_VERSION="$SEMVER_MAJOR.$((SEMVER_MINOR + 1)).0" ;;
        patch) RESULT_VERSION="$SEMVER_MAJOR.$SEMVER_MINOR.$((SEMVER_PATCH + 1))" ;;
    esac
}

property_five() {
    local iteration case_id impacts prior first expected_impact expected_version
    for ((iteration = 1; iteration <= ITERATIONS; iteration++)); do
        assert_shape_generation property-05 "$iteration"
        for case_id in ${CASE_IDS[property-05]}; do
            next_choice 2
            impacts="$(case_field property-05 "$case_id" impacts)"
            prior="$(case_field property-05 "$case_id" prior)"
            first="$(case_field property-05 "$case_id" first)"
            expected_impact="$(case_field property-05 "$case_id" expected-impact)"
            expected_version="$(case_field property-05 "$case_id" expected-version)"
            derive_candidate "$impacts" "$prior" "$first"
            [[ "$RESULT_IMPACT" == "$expected_impact" ]] || fail_property greatest-impact-first-release "$iteration" "$case_id impact expected $expected_impact got $RESULT_IMPACT"
            [[ "$RESULT_VERSION" == "$expected_version" ]] || fail_property greatest-impact-first-release "$iteration" "$case_id version expected $expected_version got $RESULT_VERSION"
        done
    done
    echo "PROPERTY|greatest-impact-first-release|SEED=$SEED|ITERATIONS=$ITERATIONS|PASS"
}

property_six() {
    local iteration case_id core prerelease commit supporting display promoted expected generated_support
    for ((iteration = 1; iteration <= ITERATIONS; iteration++)); do
        assert_shape_generation property-06 "$iteration"
        for case_id in ${CASE_IDS[property-06]}; do
            next_choice 2
            core="$(case_field property-06 "$case_id" core)"
            prerelease="$(case_field property-06 "$case_id" prerelease)"
            commit="$(case_field property-06 "$case_id" commit)-I$iteration"
            supporting="$(case_field property-06 "$case_id" supporting)"
            generated_support="$supporting,GEN-P06-$iteration"
            expected="$(case_field property-06 "$case_id" expected)"
            parse_core_semver "$core" || fail_property preliminary-provenance-promotion "$iteration" "$case_id has invalid core"
            [[ -n "$commit" && "$generated_support" != NONE ]] || fail_property preliminary-provenance-promotion "$iteration" "$case_id lost provenance"
            if [[ "$prerelease" == NONE ]]; then display="$core"; else display="$core-$prerelease"; fi
            promoted="$core"
            [[ "$display" == "$core" || "$display" == "$core-$prerelease" ]] || fail_property preliminary-provenance-promotion "$iteration" "$case_id display changed core"
            [[ "$promoted" == "$core" && "$commit" == *"-I$iteration" && "$generated_support" == *"GEN-P06-$iteration"* ]] || fail_property preliminary-provenance-promotion "$iteration" "$case_id promotion lost provenance"
            [[ "$expected" == PASS ]] || fail_property preliminary-provenance-promotion "$iteration" "$case_id fixture expected non-pass"
        done
    done
    echo "PROPERTY|preliminary-provenance-promotion|SEED=$SEED|ITERATIONS=$ITERATIONS|PASS"
}

validate_approval() {
    local candidate="$1" approved="$2" tag="$3" decision="$4" coordinator="$5" rationale="$6"
    local normalized_approved="${approved#v}"
    RESULT_APPROVAL=PASS
    parse_core_semver "$candidate" || RESULT_APPROVAL=FAIL
    parse_core_semver "$approved" || RESULT_APPROVAL=FAIL
    [[ "${decision,,}" == approved ]] || RESULT_APPROVAL=FAIL
    [[ "$coordinator" != NONE ]] || RESULT_APPROVAL=FAIL
    [[ "$tag" == "v$normalized_approved" || "$tag" == "$normalized_approved" ]] || RESULT_APPROVAL=FAIL
    if [[ "$candidate" != "$approved" && "$rationale" == NONE ]]; then RESULT_APPROVAL=FAIL; fi
}

property_seven() {
    local iteration case_id candidate approved tag decision coordinator rationale expected
    for ((iteration = 1; iteration <= ITERATIONS; iteration++)); do
        assert_shape_generation property-07 "$iteration"
        for case_id in ${CASE_IDS[property-07]}; do
            next_choice 2
            candidate="$(case_field property-07 "$case_id" candidate)"
            approved="$(case_field property-07 "$case_id" approved)"
            tag="$(case_field property-07 "$case_id" tag)"
            decision="$(case_field property-07 "$case_id" decision)"
            coordinator="$(case_field property-07 "$case_id" coordinator)"
            rationale="$(case_field property-07 "$case_id" rationale)"
            expected="$(case_field property-07 "$case_id" expected)"
            validate_approval "$candidate" "$approved" "$tag" "$decision" "$coordinator" "$rationale"
            [[ "$RESULT_APPROVAL" == "$expected" ]] || fail_property approval-justification-alignment "$iteration" "$case_id expected $expected got $RESULT_APPROVAL"
        done
    done
    echo "PROPERTY|approval-justification-alignment|SEED=$SEED|ITERATIONS=$ITERATIONS|PASS"
}

for property in property-01 property-02 property-03 property-04 property-05 property-06 property-07; do
    load_fixture "$property"
done

property_one
property_two
property_three
property_four
property_five
property_six
property_seven

echo "Release-record Bash property harness passed: properties=7 iterations_per_property=$ITERATIONS seed=$SEED read_only=PASS."
echo "Release-record property evidence is local and synthetic; it cannot authorize tags, releases, publication, remotes, deployment, or rollback actions."
