Class {
	#name : #GtLlmActionMessageWithInstanceSerializer,
	#superclass : #GtLlmActionMessageSerializer,
	#instVars : [
		'instance'
	],
	#category : 'Gt4Llm'
}

{ #category : #'as yet unclassified' }
GtLlmActionMessageWithInstanceSerializer >> gtInstanceFor: aView [
	<gtView>
	self instance ifNil: [ ^ aView empty ].
	self gtDo: [] gemstoneDo: [ ^ aView empty ].

	^ aView forward
		title: 'Instance';
		priority: 1;
		object: [ self instance ];
		view: #gtLiveFor:
]

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
