Class {
	#name : #GtLProviderFactoryAnnouncement,
	#superclass : #GtLAnnouncement,
	#instVars : [
		'providerClass'
	],
	#category : #'Gt4LlmCore-Announcements'
}

{ #category : #accessing }
GtLProviderFactoryAnnouncement >> providerClass [
	^ providerClass
]

{ #category : #accessing }
GtLProviderFactoryAnnouncement >> providerClass: anObject [
	providerClass := anObject
]
