Class {
	#name : #Gt4OpenAIAssistantChatElement,
	#superclass : #BlElement,
	#traits : 'TGt4OpenAIWithAssistantChat + TBrLayoutResizable',
	#classTraits : 'TGt4OpenAIWithAssistantChat classTrait + TBrLayoutResizable classTrait',
	#instVars : [
		'listElement'
	],
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #'initialization ' }
Gt4OpenAIAssistantChatElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #initialization }
Gt4OpenAIAssistantChatElement >> initialize [
	super initialize.
	self initializeListElement.
	self addChild: listElement as: #list.
	self padding: (BlInsets all: 5).
	self matchParent
]

{ #category : #initialization }
Gt4OpenAIAssistantChatElement >> initializeListElement [
	listElement := BrSimpleList new
			hMatchParent;
			vMatchParent;
			padding: (BlInsets all: 5);
			itemStencil: [ Gt4OpenAIThreadMessageElement new
				background: Color white;
				addAptitude: BrGlamorousFocusableShadowAptitude new;
				margin: (BlInsets bottom: 3) ];
			itemDataBinder: [ :anItemElement :anItem | anItemElement threadMessage: anItem ]
]

{ #category : #'private - hooks' }
Gt4OpenAIAssistantChatElement >> onAssistantChatChanged [
	self updateElement
]

{ #category : #'private - updating' }
Gt4OpenAIAssistantChatElement >> updateElement [
	self updateListElement
]

{ #category : #'private - updating' }
Gt4OpenAIAssistantChatElement >> updateListElement [
	listElement items: assistantChat messages asArray reversed
]
