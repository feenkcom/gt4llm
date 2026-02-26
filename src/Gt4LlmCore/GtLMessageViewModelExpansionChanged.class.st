Class {
	#name : #GtLMessageViewModelExpansionChanged,
	#superclass : #GtLMessageViewModelAnnouncement,
	#instVars : [
		'isExpanded'
	],
	#category : 'Gt4LlmCore-Announcements'
}

{ #category : #accessing }
GtLMessageViewModelExpansionChanged >> isExpanded [
	^ isExpanded
]

{ #category : #accessing }
GtLMessageViewModelExpansionChanged >> isExpanded: aBoolean [
	isExpanded := aBoolean
]
