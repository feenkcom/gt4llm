Class {
	#name : #GtOpenAIGroup,
	#superclass : #Object,
	#traits : 'TGtGroupWithItems',
	#classTraits : 'TGtGroupWithItems classTrait',
	#instVars : [
		'client'
	],
	#category : #Gt4OpenAI
}

{ #category : #'instance creation' }
GtOpenAIGroup class >> from: aList [
	^ self
		withAll: ((aList at: 'data') collect: [ :aModel | self itemClass from: aModel ])
]

{ #category : #accessing }
GtOpenAIGroup class >> itemClass [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtOpenAIGroup >> client [
	^ client
]

{ #category : #accessing }
GtOpenAIGroup >> client: anObject [
	client := anObject.

	self do: [ :anItem | anItem client: client ]
]
