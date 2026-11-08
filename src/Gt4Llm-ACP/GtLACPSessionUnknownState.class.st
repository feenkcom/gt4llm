"
I preserve a state name that this version of GT does not recognize. I retain its presentation label and inherit conservative lifecycle behavior from GtLACPSessionState.
"
Class {
	#name : #GtLACPSessionUnknownState,
	#superclass : #GtLACPSessionState,
	#instVars : [
		'name'
	],
	#category : #'Gt4Llm-ACP-Session states'
}

{ #category : #testing }
GtLACPSessionUnknownState >> isUnknown [
	^ true
]

{ #category : #accessing }
GtLACPSessionUnknownState >> name [
	^ name ifNil: [ #unknown ]
]

{ #category : #accessing }
GtLACPSessionUnknownState >> name: aSymbol [
	name := aSymbol
]
