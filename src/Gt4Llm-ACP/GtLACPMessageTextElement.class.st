"
I contain the selectable styled editor for message text. I retain the message and editor, and refresh text without replacing the editor. I provide shared text presentation for user and inter-session messages and assistant comments.
"
Class {
	#name : #GtLACPMessageTextElement,
	#superclass : #BrVerticalPane,
	#instVars : [
		'message',
		'editor',
		'phlowContext'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #accessing }
GtLACPMessageTextElement >> editor [
	^ editor
]

{ #category : #initialization }
GtLACPMessageTextElement >> initialize [
	super initialize.
	self
		hMatchParent;
		vFitContentLimited.
	editor := BrEditor new
			aptitude: BrGlamorousRegularEditorAptitude;
			beReadOnlyWithSelection;
			hMatchParent;
			vFitContentLimited;
			yourself.
	self addChild: editor
]

{ #category : #accessing }
GtLACPMessageTextElement >> message [
	^ message
]

{ #category : #accessing }
GtLACPMessageTextElement >> message: aMessage [
	message := aMessage.
	self refresh
]

{ #category : #accessing }
GtLACPMessageTextElement >> phlowContext [
	^ phlowContext
]

{ #category : #accessing }
GtLACPMessageTextElement >> phlowContext: aContext [
	phlowContext := aContext
]

{ #category : #updating }
GtLACPMessageTextElement >> refresh [
	| text |
	text := message text.
	text = editor text asString ifTrue: [ ^ self ].
	editor
		text: (GtLMessageStyler new
				objectRegistry: phlowContext objectRegistry;
				privateStyle: text asRopedText)
]
