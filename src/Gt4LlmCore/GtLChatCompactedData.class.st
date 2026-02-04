Class {
	#name : #GtLChatCompactedData,
	#superclass : #Object,
	#instVars : [
		'content'
	],
	#category : 'Gt4LlmCore-Formats'
}

{ #category : #'instance creation' }
GtLChatCompactedData class >> fromOpenAICompactionMessage: aMessage [
	^ self new
		content: aMessage rawContent
]

{ #category : #accessing }
GtLChatCompactedData >> content [
	^content
]

{ #category : #accessing }
GtLChatCompactedData >> content: anObject [
	content := anObject
]

{ #category : #descriptions }
GtLChatCompactedData >> contentDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #content;
		beRequired
]

{ #category : #printing }
GtLChatCompactedData >> gtDisplayOn: aStream [
	super gtDisplayOn: aStream.
	
	aStream parenthesize: [
		aStream nextPutAll: content ]
]

{ #category : #views }
GtLChatCompactedData >> gtViewContentFor: aView [
	<gtView>
	^(aView forward)
		title: 'Content';
		object: [content];
		view: #gtStringFor:
]
