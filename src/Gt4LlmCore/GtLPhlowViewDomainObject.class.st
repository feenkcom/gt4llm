Class {
	#name : #GtLPhlowViewDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'phlowView',
		'viewMethodClassName',
		'viewMethodSourceCode',
		'phlowViewForm'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #'instance creation' }
GtLPhlowViewDomainObject class >> phlowView: aPhlowView viewMethodClassName: aClassName viewMethodSourceCode: aSourceCode [
	| form |
	aPhlowView
		asElementDo: [ :anElement | 
			| rootElement |
			rootElement := BlScripter new
					element: anElement;
					extent: 1600 @ 1200;
					elementWithoutParent.
			form := BlExporter png
					element: rootElement;
					doExport: [ :aCanvas | aCanvas asForm ] ].

	^self new
		phlowView: aPhlowView;
		phlowViewForm: form;
		viewMethodClassName: aClassName;
		viewMethodSourceCode: aSourceCode;
		yourself
]

{ #category : #views }
GtLPhlowViewDomainObject >> gtLivePhlowViewFor: aView [
	<gtView>
	<gtLlmView>
	^ aView explicit
		title: 'Phlow view';
		priority: 1;
		stencil: [ | container viewParent |
			viewParent := phlowViewForm asElement asCanvassableElement
					margin: (BlInsets all: 10);
					background: Color white;
					aptitude: BrShadowAptitude;
					constraintsDo: [ :c | 
						c horizontal matchParent.
						c vertical matchParent ].
			container := BrVerticalPane new.
			container matchParent
				addAptitude: (BrLayoutResizerAptitude new common: [ container children ]);
				background: BrGlamorousColors backdropColor;
				addChild: ((GtPharoMethodCoder new
						forMethod: self phlowView definingMethod;
						subscribeToSystem;
						asExpandedOnlyElement)
						margin: (BlInsets all: 10);
						background: Color white;
						addAptitude: BrShadowAptitude;
						vFitContentLimited);
				addChild: viewParent ]
]

{ #category : #accessing }
GtLPhlowViewDomainObject >> phlowView [
	^ phlowView
]

{ #category : #accessing }
GtLPhlowViewDomainObject >> phlowView: anObject [
	phlowView := anObject
]

{ #category : #'instance creation' }
GtLPhlowViewDomainObject >> phlowViewForm: aForm [ 
	phlowViewForm := aForm
]

{ #category : #'api - serializing' }
GtLPhlowViewDomainObject >> serializeToAnthropicResponseOutput [
	^ super serializeToAnthropicResponseOutput
		, (self serializeToLlmResponseImages collect: [ :anPrimitiveImage |
				anPrimitiveImage serializeToAnthropicResponseOutput ]).
]

{ #category : #serialization }
GtLPhlowViewDomainObject >> serializeToLlmJsonObject [
	"Return a JSON dictionary that represents the domain object."
	<return: #NeoJSONObject>
	| data |
	
	data := NeoJSONObject new
		at: #viewTitle put: phlowView title;
		at: #priority put: phlowView priority;
		yourself.
	
	viewMethodClassName ifNotNil: [ data at: #viewMethodClass put: viewMethodClassName ].
	viewMethodSourceCode ifNotNil: [ data at: #viewMethodSourceCode put: viewMethodSourceCode ].
	
	^ data
]

{ #category : #'api - serializing' }
GtLPhlowViewDomainObject >> serializeToLlmResponseImages [
	^ {GtLPrimitiveImageData
			png: (ByteArray
					streamContents: [ :out | 
						PNGReadWriter putForm: phlowViewForm onStream: out ])}
]

{ #category : #'api - serializing' }
GtLPhlowViewDomainObject >> serializeToOpenAIResponseImages [
	^ {GtLPrimitiveImageData
			png: (ByteArray
					streamContents: [ :out | 
						PNGReadWriter putForm: phlowViewForm onStream: out ])}
]

{ #category : #'api - serializing' }
GtLPhlowViewDomainObject >> serializeToOpenAIResponseOutput [
	^ super serializeToOpenAIResponseOutput
		, (self serializeToLlmResponseImages collect: [ :anPrimitiveImage |
				anPrimitiveImage serializeToOpenAIResponseOutput ])
]

{ #category : #accessing }
GtLPhlowViewDomainObject >> viewMethodClassName [
	^ viewMethodClassName
]

{ #category : #accessing }
GtLPhlowViewDomainObject >> viewMethodClassName: anObject [
	viewMethodClassName := anObject
]

{ #category : #accessing }
GtLPhlowViewDomainObject >> viewMethodSourceCode [
	^ viewMethodSourceCode
]

{ #category : #accessing }
GtLPhlowViewDomainObject >> viewMethodSourceCode: anObject [
	viewMethodSourceCode := anObject
]
