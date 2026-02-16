Class {
	#name : #GtLDemoBooleanModel,
	#superclass : #Object,
	#instVars : [
		'flag'
	],
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #accessing }
GtLDemoBooleanModel >> flag [
	^ flag
]

{ #category : #accessing }
GtLDemoBooleanModel >> flag: aBoolean [
	flag := aBoolean
]

{ #category : #magritte }
GtLDemoBooleanModel >> flagDescription [
	<magritteDescription>
	^ MABooleanDescription new
		accessor: #flag;
		comment: 'Whether the flag is enabled';
		beRequired
]
