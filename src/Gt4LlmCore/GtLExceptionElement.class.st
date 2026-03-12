Class {
	#name : #GtLExceptionElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable',
	#classTraits : 'TBrLayoutResizable classTrait',
	#instVars : [
		'exception',
		'closeButtonElement',
		'closeActionBlock'
	],
	#category : #'Gt4LlmCore-UI - Elements'
}

{ #category : #accessing }
GtLExceptionElement >> closeAction [
	^ closeActionBlock
]

{ #category : #accessing }
GtLExceptionElement >> closeAction: aBlock [
	closeActionBlock := aBlock
]

{ #category : #initialization }
GtLExceptionElement >> defaultLayout [
	^ BlLinearLayout horizontal cellSpacing: GtLSettings defaultToolbarCellSpacing
]

{ #category : #accessing }
GtLExceptionElement >> exception [
	^ exception
]

{ #category : #accessing }
GtLExceptionElement >> exception: anException [
	exception := anException.
	
	self updateElement
]

{ #category : #accessing }
GtLExceptionElement >> freeze: anException [
	self exception: (GtSystemUtility freeze: anException)
]

{ #category : #initialization }
GtLExceptionElement >> initialize [
	super initialize.
	
	closeActionBlock := [ :theExceptionElement | self removeFromParent ].

	self initializeCloseButtonElement.
	self viewModel: BrWidgetModel new.
	self
		addAptitude: (BrLayoutResizerAptitude new
				common: [ self children reject: [ :each | each == closeButtonElement ] ])
]

{ #category : #initialization }
GtLExceptionElement >> initializeCloseButtonElement [
	closeButtonElement := BrButton new
			id: #'chat--new-exception-close';
			label: 'Close exception';
			icon: BrGlamorousVectorIcons close;
			action: [ :aButton | self onCloseClick ];
			beTinySize;
			addAptitude: BrGlamorousButtonWithIconAptitude new;
			fitContent
]

{ #category : #'private - event handling' }
GtLExceptionElement >> onCloseClick [
	closeActionBlock ifNotNil: [ :aBlock | aBlock cull: self ]
]

{ #category : #'private - updating' }
GtLExceptionElement >> updateElement [
	exception ifNil: [ ^ self ].

	self removeChildren.
	self addChild: exception asDebuggableElement as: #'chat--new-exception-debug'.
	self addChild: closeButtonElement
]
