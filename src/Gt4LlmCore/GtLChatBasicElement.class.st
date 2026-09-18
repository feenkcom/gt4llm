Class {
	#name : #GtLChatBasicElement,
	#superclass : #BlElement,
	#traits : 'TGtLWithChatViewModel + TBrLayoutResizable',
	#classTraits : 'TGtLWithChatViewModel classTrait + TBrLayoutResizable classTrait',
	#category : #'Gt4LlmCore-UI - Elements'
}

{ #category : #'api - chat view model' }
GtLChatBasicElement >> chat [
	^ self chatViewModel ifNotNil: [ :anObject | anObject chat ]
]
