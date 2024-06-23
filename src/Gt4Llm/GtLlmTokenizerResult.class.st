Class {
	#name : #GtLlmTokenizerResult,
	#superclass : #PBProxyObject,
	#instVars : [
		'input',
		'model'
	],
	#category : #'Gt4Llm-Tokenizer'
}

{ #category : #accessing }
GtLlmTokenizerResult class >> pythonClass [
	^ 'gtoolkit_tiktokenize.tokenize.TokenizerResult'
]

{ #category : #accessing }
GtLlmTokenizerResult >> gtTokenizedFor: aView [
	<gtView>
	^ aView explicit
		title: 'Tokenized';
		priority: 1.5;
		stencil: [ GtLlmTokenizedStringEditor new result: self ]
]

{ #category : #accessing }
GtLlmTokenizerResult >> input [
	^ input
]

{ #category : #accessing }
GtLlmTokenizerResult >> input: anObject [
	input := anObject
]

{ #category : #accessing }
GtLlmTokenizerResult >> model [
	^ model
]

{ #category : #accessing }
GtLlmTokenizerResult >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtLlmTokenizerResult >> tokenCount [
	^ self tokens size
]
