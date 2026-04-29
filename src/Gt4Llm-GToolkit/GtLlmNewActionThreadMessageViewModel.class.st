Class {
	#name : #GtLlmNewActionThreadMessageViewModel,
	#superclass : #GtLlmNewThreadMessageViewModel,
	#category : #'Gt4Llm-GToolkit-UI'
}

{ #category : #accessing }
GtLlmNewActionThreadMessageViewModel >> actions [
	^ self threadMessage actions
]

{ #category : #'as yet unclassified' }
GtLlmNewActionThreadMessageViewModel >> currentAction [
	^ threadMessage currentAction
]

{ #category : #accessing }
GtLlmNewActionThreadMessageViewModel >> currentAction: anObject [
	threadMessage currentAction: anObject
]

{ #category : #accessing }
GtLlmNewActionThreadMessageViewModel >> elementClass [
	^ GtLlmNewActionThreadMessageElement
]

{ #category : #'as yet unclassified' }
GtLlmNewActionThreadMessageViewModel >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 1;
		stencil: [ self asElement
				margin: (BlInsets all: 10);
				background: Color white;
				addAptitude: BrShadowAptitude new ]
]
