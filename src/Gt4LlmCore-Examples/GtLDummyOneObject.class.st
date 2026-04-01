"
I am a dummy class called one.
"
Class {
	#name : #GtLDummyOneObject,
	#superclass : #Object,
	#instVars : [
		'instVarA',
		'instVarB'
	],
	#classInstVars : [
		'classInstVarA',
		'classInstVarB'
	],
	#category : #'Gt4LlmCore-Examples-Support'
}

{ #category : #accessing }
GtLDummyOneObject class >> classInstVarA [
	^ classInstVarA
]

{ #category : #accessing }
GtLDummyOneObject class >> classInstVarA: anObject [
	classInstVarA := anObject
]

{ #category : #accessing }
GtLDummyOneObject class >> classInstVarB [
	^ classInstVarB
]

{ #category : #accessing }
GtLDummyOneObject class >> classInstVarB: anObject [
	classInstVarB := anObject
]

{ #category : #accessing }
GtLDummyOneObject >> instVarA [
	^ instVarA
]

{ #category : #accessing }
GtLDummyOneObject >> instVarA: anObject [
	instVarA := anObject
]

{ #category : #accessing }
GtLDummyOneObject >> instVarB [
	^ instVarB
]

{ #category : #accessing }
GtLDummyOneObject >> instVarB: anObject [
	instVarB := anObject
]
