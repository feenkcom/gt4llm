Class {
	#name : #GtLlmMessageMethod,
	#superclass : #Object,
	#instVars : [
		'methodClass',
		'methodBody'
	],
	#category : #'Gt4Llm-Models'
}

{ #category : #accessing }
GtLlmMessageMethod >> coder [
	^ (GtPharoMethodCoder forNewMethod: self methodClass)
		sourceCode: (GtCoderExplicitStringSource new source: self methodBody)
]

{ #category : #accessing }
GtLlmMessageMethod >> gtLiveFor: aView [
	<gtView>
	^ aView forward
		title: 'Live';
		priority: 1;
		object: [ self coder ];
		view: #gtLiveFor:
]

{ #category : #accessing }
GtLlmMessageMethod >> methodBody [
	^ methodBody
]

{ #category : #accessing }
GtLlmMessageMethod >> methodBody: anObject [
	methodBody := anObject
]

{ #category : #accessing }
GtLlmMessageMethod >> methodClass [
	^ methodClass
]

{ #category : #accessing }
GtLlmMessageMethod >> methodClass: anObject [
	methodClass := anObject
]
