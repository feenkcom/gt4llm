Class {
	#name : #GtLlmActionMessageWithInstanceSerializer,
	#superclass : #GtLlmActionMessageSerializer,
	#instVars : [
		'instance'
	],
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmActionMessageWithInstanceSerializer >> instance [
	^ instance
]

{ #category : #accessing }
GtLlmActionMessageWithInstanceSerializer >> instance: anObject [
	instance := anObject
]

{ #category : #'as yet unclassified' }
GtLlmActionMessageWithInstanceSerializer >> serialize: aString [
	^ STONJSON
		toString: {'Action' -> aString.
				self instance serialize} asDictionary
]

{ #category : #'as yet unclassified' }
GtLlmActionMessageWithInstanceSerializer >> update: aValue [
	self instance updateContent: aValue
]
