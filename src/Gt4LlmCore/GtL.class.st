Class {
	#name : #GtL,
	#superclass : #Object,
	#category : 'Gt4LlmCore-Coree'
}

{ #category : #'instance creation' }
GtL class >> chat [
	^ GtLChatRegistry current chat
]

{ #category : #'instance creation' }
GtL class >> gt [
	^ GtLChatRegistry current newGtChat
]

{ #category : #'instance creation' }
GtL class >> gtChat [
	^ GtLChatRegistry current gtChat
]

{ #category : #'class initialization' }
GtL class >> gtChatsFor: aView [
	<gtClassView>
	^ aView forward
		title: 'Chats';
		priority: 2;
		object: [ self registry ];
		view: #gtViewChatsOn:
]

{ #category : #'instance creation' }
GtL class >> registry [
	^ GtLChatRegistry current
]
