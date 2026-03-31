Class {
	#name : #GtLForwardDataView,
	#superclass : #GtLDataViewDecorator,
	#instVars : [
		'objectComputation',
		'computedTargetObject',
		'viewSymbol',
		'computedTargetView'
	],
	#category : #Gt4LlmCore
}

{ #category : #testing }
GtLForwardDataView class >> isAbstract [
	^ self name = #GtLForwardDataView 
]

{ #category : #accessing }
GtLForwardDataView >> computeForwardedViewFor: anObjectComputation [
	| targetObject computedView |
	
	[ targetObject := anObjectComputation value ] 
		on: Error do: [ :anError |
			^ self 
				errorViewWithException: anError 
				reason: 'Error computing target object for object forwarded data view' 
				isFrozen: false ].
	
	computedView := self on: targetObject perform: self viewSymbol.
	
	computedView class = GtLForwardObjectDataView ifTrue: [
		"If this forward is to another forward view we follow the chain
		to reach the first view that is now a forward view."
		^ computedView computeForwardedView ].
		
	^ computedView
]

{ #category : #accessing }
GtLForwardDataView >> computeTargetView [
	self subclassResponsibility
]

{ #category : #'gt - extensions' }
GtLForwardDataView >> gtPhlowTreeChildren [
	^ {self targetDataView}
]

{ #category : #'gt - extensions' }
GtLForwardDataView >> gtViewContentJsonStringFor: aView [
	<gtView>
	<gtLlmMessageView>
	
	^(aView forward)
		title: 'JSON String';
		priority: 30.1;
		object: [ self serializeToLlmPrimiteData  ];
		view: #gtViewCondensedJsonStringFor:
]

{ #category : #'api - scripting' }
GtLForwardDataView >> object: aBlockClosure [
	objectComputation := aBlockClosure.
	computedTargetObject := nil.
	computedTargetView := nil.
]

{ #category : #serialization }
GtLForwardDataView >> serializeToLlmPrimiteDataOn: aBuilder [
	self targetDataView serializeToLlmPrimiteDataOn: aBuilder 
]

{ #category : #accessing }
GtLForwardDataView >> targetDataView [
	^computedTargetView ifNil: [
		computedTargetView := self computeTargetView.
		dataKey ifNotNil: [ :aDataKey |
			computedTargetView dataKey: aDataKey ].
		computedTargetView ]
]

{ #category : #accessing }
GtLForwardDataView >> targetObject [
	^computedTargetObject ifNil: [
		computedTargetObject := objectComputation value ]
]

{ #category : #'api - scripting' }
GtLForwardDataView >> view: aSymbol [
	viewSymbol := aSymbol asSymbol
]

{ #category : #accessing }
GtLForwardDataView >> viewSymbol [
	^viewSymbol ifNil: [ #llmDataViewsFor:	]
]
