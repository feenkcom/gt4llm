Class {
	#name : #GtLProviderFactoryConnectabilityChanged,
	#superclass : #GtLProviderFactoryAnnouncement,
	#instVars : [
		'isConnectable'
	],
	#category : #'Gt4LlmCore-Announcements'
}

{ #category : #accessing }
GtLProviderFactoryConnectabilityChanged >> isConnectable [
	^ isConnectable
]

{ #category : #accessing }
GtLProviderFactoryConnectabilityChanged >> isConnectable: anObject [
	isConnectable := anObject
]
