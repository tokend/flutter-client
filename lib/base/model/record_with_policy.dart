abstract class RecordWithPolicy {
  abstract int policy;
}

extension PolicyCheck on RecordWithPolicy {
  bool hasPolicy(int value) {
    return this.policy == value;
  }
}
