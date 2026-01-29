Class {
	#name : #GtLDemoMathReasoningExplanationStep,
	#superclass : #GtLDemoMathReasoningBasicStep,
	#instVars : [
		'content'
	],
	#category : 'Gt4LlmCore-Examples-Magritte'
}

{ #category : #comparing }
GtLDemoMathReasoningExplanationStep class >> jsonSchemaLabel [
	^ 'ExplanationStep'
]

{ #category : #comparing }
GtLDemoMathReasoningExplanationStep >> = anObject [

	"Answer whether the receiver and anObject represent the same object."

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ content = anObject content 
]

{ #category : #accessing }
GtLDemoMathReasoningExplanationStep >> content [
	^ content
]

{ #category : #accessing }
GtLDemoMathReasoningExplanationStep >> content: anObject [
	content := anObject
]

{ #category : #accessing }
GtLDemoMathReasoningExplanationStep >> contentDescription [
	<magritteDescription>
	
	^ MAStringDescription new
		  accessor: #content;
		  comment: 'An explanation of this step';
		  beRequired
]

{ #category : #accessing }
GtLDemoMathReasoningExplanationStep >> description [
	^ self content
]

{ #category : #comparing }
GtLDemoMathReasoningExplanationStep >> hash [
	^ self class hash hashMultiply bitXor: content hash hashMultiply
]
