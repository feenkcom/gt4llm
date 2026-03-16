"
A dedicated Phlow tool for presenting a GtLChat through its chat widget.
"
Class {
	#name : #GtPhlowChatTool,
	#superclass : #GtPhlowTool,
	#instVars : [
		'chat'
	],
	#category : #Gt4LlmCore
}

{ #category : #'instance creation' }
GtPhlowChatTool class >> forChat: aChat [
	^ self new
		chat: aChat
]

{ #category : #converting }
GtPhlowChatTool >> asElementDo: aOneArgBlock [
	| toolElement |
	toolElement := GtPhlowChatToolElement new
		chat: self chat.
	^ aOneArgBlock cull: toolElement cull: self
]

{ #category : #accessing }
GtPhlowChatTool >> chat [
	^ chat
]

{ #category : #accessing }
GtPhlowChatTool >> chat: aChat [
	chat := aChat
]

{ #category : #private }
GtPhlowChatTool >> collectToolViews [
	^ GtPhlowViewsCollector new
		pragmaName: #gtLlmView;
		fromObject: self chat;
		collect
]

{ #category : #accessing }
GtPhlowChatTool >> icon [
	^ BrGlamorousVectorIcons chat
]

{ #category : #accessing }
GtPhlowChatTool >> name [
	^ 'Chat'
]

{ #category : #accessing }
GtPhlowChatTool >> object [
	^ self chat
]

{ #category : #accessing }
GtPhlowChatTool >> object: aChat [
	self chat: aChat
]

{ #category : #accessing }
GtPhlowChatTool >> tabLook [
	^ BrGlamorousTabSwitcherWithIconAptitude
]
