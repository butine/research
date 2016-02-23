package org.blockchain.borrowing.bitcoin.client.domain;

public class EntryCommit {
    private CommitEntryMsg EntryCommit;
    private EntryReveal EntryReveal;

    public CommitEntryMsg getEntryCommit() {
        return EntryCommit;
    }

    public void setEntryCommit(CommitEntryMsg entryCommit) {
        EntryCommit = entryCommit;
    }

    public org.blockchain.borrowing.bitcoin.client.domain.EntryReveal getEntryReveal() {
        return EntryReveal;
    }

    public void setEntryReveal(org.blockchain.borrowing.bitcoin.client.domain.EntryReveal entryReveal) {
        EntryReveal = entryReveal;
    }

    public String getHash() {
        return EntryCommit.getCommitEntryMsg().substring(14, 78);
    }
}

class CommitEntryMsg {
    private String CommitEntryMsg;

    public String getCommitEntryMsg() {
        return CommitEntryMsg;
    }

    public void setCommitEntryMsg(String commitEntryMsg) {
        CommitEntryMsg = commitEntryMsg;
    }
}

class EntryReveal {
    private String Entry;

    public String getEntry() {
        return Entry;
    }

    public void setEntry(String entry) {
        Entry = entry;
    }
}