Class {
	#name : #GtLACPSessionTool,
	#superclass : #GtPhlowTool,
	#instVars : [
		'session',
		'interactionToReveal'
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
	element := GtLACPSessionToolElement new
			interactionToReveal: interactionToReveal;
			chat: self session;
			yourself.
	^ aBlock cull: element cull: self
]

{ #category : #converting }
GtLACPSessionTool >> icon [
	^ BrGlamorousVectorIcons chat
]

{ #category : #accessing }
GtLACPSessionTool >> interactionToReveal: aRequest [
	interactionToReveal := aRequest
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
