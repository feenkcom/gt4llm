Class {
	#name : #GtPossibleRenameSelectorAction,
	#superclass : #GtCoderViewModelRenameAction,
	#instVars : [
		'newSelector',
		'styler',
		'hasArguments',
		'possibilities'
	],
	#category : #'Gt4Llm-Coder'
}

{ #category : #accessing }
GtPossibleRenameSelectorAction class >> message: aGtPharoMessageNode textualCoderViewModel: aTextualCoderViewModel [
	^ self new
		message: aGtPharoMessageNode;
		pharoSourceCoderViewModel: aTextualCoderViewModel;
		yourself
]

{ #category : #accessing }
GtPossibleRenameSelectorAction class >> message: aGtPharoMessageNode textualCoderViewModel: aTextualCoderViewModel possibilities: aListOfPossibilities [
	^ self new
		message: aGtPharoMessageNode;
		pharoSourceCoderViewModel: aTextualCoderViewModel;
		possibilities: aListOfPossibilities;
		yourself
]

{ #category : #accessing }
GtPossibleRenameSelectorAction class >> selector: aGtPharoLiteralNode textualCoderViewModel: aTextualCoderViewModel [
	^ self new
		selector: aGtPharoLiteralNode;
		pharoSourceCoderViewModel: aTextualCoderViewModel;
		yourself
]

{ #category : #accessing }
GtPossibleRenameSelectorAction class >> variable: aGtPharoVariableNode textualCoderViewModel: aTextualCoderViewModel [
	^ self new
		variable: aGtPharoVariableNode;
		pharoSourceCoderViewModel: aTextualCoderViewModel;
		yourself
]

{ #category : #accessing }
GtPossibleRenameSelectorAction >> addRenameAttributes [
	| text original |
	text := self pharoSourceCoderViewModel styledText
			ifNil: [ self pharoSourceCoderViewModel sourceText ].

	original := ''
			join: (originalLocations
					collect: [ :aLocation | (text from: aLocation first to: aLocation last) asString ]).

	self pharoSourceCoderViewModel
		addTextAttribute: (GtProposeRenamesAttribute new
				renameAction: self;
				original: original;
				possibilities: self possibilities)
		from: originalLocations last last + 1
		to: originalLocations last last + 1
]

{ #category : #accessing }
GtPossibleRenameSelectorAction >> forBinaryOrKeyword [
	validationBlock := [ :str | 
		(self validateKeyword: str)
			or: [ (self validateBinary: str) or: [ self validateVariable: str ] ] ].
	styler := GtSelectorStyler new forBinaryOrKeyword.
	filter := GtSelectorInputFilter forBinaryOrKeywordMessage
]

{ #category : #accessing }
GtPossibleRenameSelectorAction >> forKeyword [
	validationBlock := [ :str | (self validateKeyword: str) or: [ self validateVariable: str ] ].
	styler := GtSelectorStyler new forKeyword.
	filter := GtSelectorInputFilter forKeywordMessage
]

{ #category : #accessing }
GtPossibleRenameSelectorAction >> forVariableOrUnaryMessage [
	super forVariableOrUnaryMessage.
	styler := GtSelectorStyler new forUnary.
	filter := GtSelectorInputFilter forUnaryMessage
]

{ #category : #accessing }
GtPossibleRenameSelectorAction >> initialize [
	super initialize.
	allowAccept := false.
	focusedIndex := 1.
	self hasRefactoringPreview: true
]

{ #category : #accessing }
GtPossibleRenameSelectorAction >> message: aGtPharoMessageNode [
	originalLocations := aGtPharoMessageNode selectorParts
			collect: [ :each | each sourceInterval ].
	hasArguments := aGtPharoMessageNode arguments notEmpty.
	hasArguments
		ifTrue: [ aGtPharoMessageNode arguments size = 1
				ifTrue: [ self forBinaryOrKeyword ]
				ifFalse: [ self forKeyword ] ]
		ifFalse: [ self forVariableOrUnaryMessage ]
]

{ #category : #accessing }
GtPossibleRenameSelectorAction >> newSelector [
	^ renameAttributes
		ifNil: [ newSelector ]
		ifNotNil: [ (String
				streamContents: [ :stream | 
					renameAttributes
						do: [ :each | 
							| selector |
							selector := each text asString.
							stream nextPutAll: selector.
							(hasArguments and: [ selector numArgs < 1 ])
								ifTrue: [ stream nextPut: $: ] ] ]) asSymbol ]
]

{ #category : #accessing }
GtPossibleRenameSelectorAction >> newSelector: aSymbol [
	newSelector := aSymbol
]

{ #category : #accessing }
GtPossibleRenameSelectorAction >> newVariableName [
	^ self newSelector
]

{ #category : #accessing }
GtPossibleRenameSelectorAction >> possibilities [
	^ possibilities
]

{ #category : #accessing }
GtPossibleRenameSelectorAction >> possibilities: anObject [
	possibilities := anObject
]

{ #category : #accessing }
GtPossibleRenameSelectorAction >> selector: aGtPharoLiteralNode [
	| interval |
	interval := aGtPharoLiteralNode sourceInterval.
	aGtPharoLiteralNode value source first = $#
		ifTrue: [ interval := interval first + 1 to: interval last ].
	originalLocations := {interval}.
	hasArguments := false.
	self forVariableOrUnaryMessage
]

{ #category : #accessing }
GtPossibleRenameSelectorAction >> tabAccept: forward [
]

{ #category : #accessing }
GtPossibleRenameSelectorAction >> updateName: aString [
	| text |
	text := self pharoSourceCoderViewModel styledText
			ifNil: [ self pharoSourceCoderViewModel sourceText ].

	newSelector := aString asSymbol.

	self announceEvent: #textUpdated
]

{ #category : #accessing }
GtPossibleRenameSelectorAction >> variable: aGtPharoVariableNode [
	originalLocations := {aGtPharoVariableNode sourceInterval}.
	hasArguments := false.
	self forVariableOrUnaryMessage
]
