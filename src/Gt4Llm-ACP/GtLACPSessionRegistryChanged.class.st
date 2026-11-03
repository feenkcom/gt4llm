"
I announce that something changed in the conversations of a registered session: its state, its messages or its subagents. The registry forwards me from the connections of its sessions, and I fire on every message update while an agent is streaming.
"
Class {
	#name : #GtLACPSessionRegistryChanged,
	#superclass : #GtLACPSessionRegistryAnnouncement,
	#category : #'Gt4Llm-ACP-Announcements'
}
