"
I am an example object that has a forward view. The forward view forwards to a configurable target object and view. I am used to test chained forwarding.
"
Class {
	#name : #GtLObjectWithForwardViewForExamples,
	#superclass : #GtLObjectWithViewsForExamples,
	#instVars : [
		'targetObject',
		'targetViewSymbol',
		'forwardViewDataKey'
	],
	#category : 'Gt4LlmCore-Examples-Data Views'
}

{ #category : #accessing }
GtLObjectWithForwardViewForExamples >> forwardViewDataKey [
	^ forwardViewDataKey
]

{ #category : #accessing }
GtLObjectWithForwardViewForExamples >> forwardViewDataKey: aSymbol [
	forwardViewDataKey := aSymbol
]

{ #category : #'llm views' }
GtLObjectWithForwardViewForExamples >> gtLlmForwardViewFor: aDataView [
	<gtLlmDataView>
	| forwardView |
	forwardView := aDataView forwardObject
		object: [ self targetObject ].
	
	self targetViewSymbol ifNotNil: [ :viewSymbol |
		forwardView view: viewSymbol ].
	
	self forwardViewDataKey ifNotNil: [ :dataKey |
		forwardView dataKey: dataKey ].
	
	^ forwardView
]

{ #category : #accessing }
GtLObjectWithForwardViewForExamples >> targetObject [
	^ targetObject
]

{ #category : #accessing }
GtLObjectWithForwardViewForExamples >> targetObject: anObject [
	targetObject := anObject
]

{ #category : #accessing }
GtLObjectWithForwardViewForExamples >> targetViewSymbol [
	^ targetViewSymbol
]

{ #category : #accessing }
GtLObjectWithForwardViewForExamples >> targetViewSymbol: aSymbol [
	targetViewSymbol := aSymbol
]
