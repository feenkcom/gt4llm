Class {
	#name : #GtLGeneralPurposeAgent,
	#superclass : #GtLAgent,
	#category : #'Gt4LlmCore-Agents'
}

{ #category : #accessing }
GtLGeneralPurposeAgent >> description [
	^ 'A generic agent that can be specialized for a complex task. By default is has access to all the tools of the current chat. ' "Lepiter pages can be used to indicate its instructions."
]

{ #category : #accessing }
GtLGeneralPurposeAgent >> lepiterExplanationPageName [
	^ 'Instructions for the General-Purpose Coding Agent'
]

{ #category : #accessing }
GtLGeneralPurposeAgent >> name [
	^ 'generalPurpose'
]
