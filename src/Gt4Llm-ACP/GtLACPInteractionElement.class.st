"
I provide shared layout, selectable text, toolbars, buttons and error handling for permission and elicitation elements. Concrete subclasses render their own headers and pending or resolved content. Models retain interaction state independently of these disposable elements.
"
Class {
	#name : #GtLACPInteractionElement,
	#superclass : #BrVerticalPane,
	#instVars : [
		'request',
		'errorLabel'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #navigation }
GtLACPInteractionElement >> attentionTarget [
	^ self
]

{ #category : #building }
GtLACPInteractionElement >> build [
	self removeChildren.
	self buildHeader.
	request state = #pending
		ifTrue: [ self buildPendingContent ]
		ifFalse: [ self buildResolvedContent ]
]

{ #category : #building }
GtLACPInteractionElement >> buildHeader [
	self subclassResponsibility
]

{ #category : #building }
GtLACPInteractionElement >> buildPendingContent [
	self subclassResponsibility
]

{ #category : #building }
GtLACPInteractionElement >> buildResolvedContent [
	self subclassResponsibility
]

{ #category : #building }
GtLACPInteractionElement >> button: aLabel id: anId action: aBlock [
	^ BrButton new
		id: anId;
		aptitude: BrGlamorousButtonWithLabelAptitude;
		label: aLabel;
		action: [ self performAction: aBlock ];
		yourself
]

{ #category : #initialization }
GtLACPInteractionElement >> initialize [
	super initialize.
	self
		hMatchParent;
		vFitContent;
		padding: (BlInsets all: 8);
		margin: (BlInsets top: 4 bottom: 4).
	errorLabel := BrLabel new
			aptitude: BrGlamorousLabelAptitude;
			visibility: BlVisibility gone;
			text: '';
			yourself
]

{ #category : #building }
GtLACPInteractionElement >> newToolbar [
	^ BrToolbar new
		aptitude: BrGlamorousToolbarAptitude;
		hMatchParent;
		vFitContent;
		yourself
]

{ #category : #actions }
GtLACPInteractionElement >> performAction: aBlock [
	[ errorLabel visibility: BlVisibility gone.
	aBlock value.
	request state = #pending ifFalse: [ self build ] ]
		on: Error
		do: [ :ex | 
			errorLabel
				text: ex messageText;
				visibility: BlVisibility visible ]
]

{ #category : #building }
GtLACPInteractionElement >> secondaryText: aString [
	^ self text: (aString asRopedText foreground: Color gray)
]

{ #category : #building }
GtLACPInteractionElement >> text: aString [
	^ BrEditor new
		aptitude: BrGlamorousRegularEditorAptitude;
		hMatchParent;
		vFitContent;
		beReadOnlyWithSelection;
		text: aString;
		yourself
]
