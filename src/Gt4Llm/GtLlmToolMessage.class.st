Class {
	#name : #GtLlmToolMessage,
	#superclass : #GtLlmChatMessage,
	#instVars : [
		'toolCall',
		'output'
	],
	#category : #'Gt4Llm-Models'
}

{ #category : #'as yet unclassified' }
GtLlmToolMessage class >> defaultRole [
	^ 'tool'
]

{ #category : #'as yet unclassified' }
GtLlmToolMessage >> action [
	^ 'Tool call: ' , self toolCall name
]

{ #category : #'as yet unclassified' }
GtLlmToolMessage >> actionModel [
	^ self toolCall
]

{ #category : #'as yet unclassified' }
GtLlmToolMessage >> content [
	^ self output
]

{ #category : #'as yet unclassified' }
GtLlmToolMessage >> contentText [
	^ ''
]

{ #category : #'as yet unclassified' }
GtLlmToolMessage >> gtArgumentsFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView forward
		title: 'Arguments';
		priority: 5;
		object: [ self toolCall ];
		view: #gtArgumentsFor:
]

{ #category : #'as yet unclassified' }
GtLlmToolMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView empty
]

{ #category : #'as yet unclassified' }
GtLlmToolMessage >> gtOutputFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView textEditor
		title: 'Output';
		priority: 1;
		text: [ self output ]
]

{ #category : #accessing }
GtLlmToolMessage >> output [
	^ output
]

{ #category : #accessing }
GtLlmToolMessage >> output: anObject [
	output := anObject
]

{ #category : #accessing }
GtLlmToolMessage >> toolCall [
	^ toolCall
]

{ #category : #accessing }
GtLlmToolMessage >> toolCall: anObject [
	toolCall := anObject
]
