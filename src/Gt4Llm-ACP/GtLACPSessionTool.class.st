Class {
	#name : #GtLACPSessionTool,
	#superclass : #GtPhlowTool,
	#instVars : [
		'session'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #'instance creation' }
GtLACPSessionTool class >> forSession: aSession [
	^ self new session: aSession
]

{ #category : #converting }
GtLACPSessionTool >> asElementDo: aBlock [
	| element |
	element := GtLACPSessionToolElement new chat: self session.
	^ aBlock cull: element cull: self
]

{ #category : #converting }
GtLACPSessionTool >> icon [
	^ BrGlamorousVectorIcons chat
]

{ #category : #accessing }
GtLACPSessionTool >> name [
	^ 'ACP Session'
]

{ #category : #accessing }
GtLACPSessionTool >> object [
	^ self session
]

{ #category : #accessing }
GtLACPSessionTool >> object: aSession [
	self session: aSession
]

{ #category : #accessing }
GtLACPSessionTool >> session [
	^ session
]

{ #category : #accessing }
GtLACPSessionTool >> session: aSession [
	session := aSession
]

{ #category : #converting }
GtLACPSessionTool >> tabLook [
	^ BrGlamorousTabSwitcherWithIconAptitude
]
