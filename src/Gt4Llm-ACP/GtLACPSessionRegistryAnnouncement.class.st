"
I am the root of the announcements made by a GtLACPSessionRegistry. Subscribe to me to follow any change in the registry, as the registry views do.
"
Class {
	#name : #GtLACPSessionRegistryAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'registry'
	],
	#category : #'Gt4Llm-ACP-Announcements'
}

{ #category : #testing }
GtLACPSessionRegistryAnnouncement >> isSessionRegistration [
	^ false
]

{ #category : #accessing }
GtLACPSessionRegistryAnnouncement >> registry [
	^ registry
]

{ #category : #accessing }
GtLACPSessionRegistryAnnouncement >> registry: aRegistry [
	registry := aRegistry
]
