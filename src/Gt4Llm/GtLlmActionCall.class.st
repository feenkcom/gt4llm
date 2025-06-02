Class {
	#name : #GtLlmActionCall,
	#superclass : #Announcement,
	#instVars : [
		'action',
		'arguments'
	],
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmActionCall class >> action: aString [
	^ self new action: aString
]

{ #category : #accessing }
GtLlmActionCall class >> action: aString arguments: aListOfStrings [
	^ self new
		action: aString;
		arguments: aListOfStrings
]

{ #category : #accessing }
GtLlmActionCall >> action [
	^ action
]

{ #category : #accessing }
GtLlmActionCall >> action: anObject [
	action := anObject
]

{ #category : #accessing }
GtLlmActionCall >> arguments [
	^ arguments
]

{ #category : #accessing }
GtLlmActionCall >> arguments: anObject [
	arguments := anObject
]

{ #category : #'as yet unclassified' }
GtLlmActionCall >> initialize [
	arguments := {}
]
