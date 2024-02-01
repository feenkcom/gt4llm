Class {
	#name : #Gt4OpenAIGroup,
	#superclass : #Object,
	#traits : 'TGtGroupWithItems',
	#classTraits : 'TGtGroupWithItems classTrait',
	#instVars : [
		'client'
	],
	#category : #'Gt4OpenAI-Models'
}

{ #category : #'instance creation' }
Gt4OpenAIGroup class >> from: aList [
	^ self
		withAll: ((aList at: 'data') collect: [ :aModel | self itemClass from: aModel ])
]

{ #category : #accessing }
Gt4OpenAIGroup class >> itemClass [
	^ self subclassResponsibility
]

{ #category : #accessing }
Gt4OpenAIGroup >> client [
	^ client
]

{ #category : #accessing }
Gt4OpenAIGroup >> client: anObject [
	client := anObject.

	self do: [ :anItem | anItem client: client ]
]
