"
Represents an explicit entry stored in a GtLObjectStorage. It keeps the generated id, the stored value, and a textual reason describing why the object was stored.
"
Class {
	#name : #GtLStoredObject,
	#superclass : #Object,
	#instVars : [
		'id',
		'value',
		'reason',
		'objectStorage'
	],
	#category : #'Gt4LlmCore-Object Storage'
}

{ #category : #'instance creation' }
GtLStoredObject class >> id: anId value: anObject reason: aReason [
	^ self new
		initializeWithId: anId
		value: anObject
		reason: aReason
]

{ #category : #'gt extensions' }
GtLStoredObject >> gtInspectorTargetModels [
	| aReason |
	aReason := self reason.
	^ {aReason} , aReason gtInspectorTargetModels
]

{ #category : #'as yet unclassified' }
GtLStoredObject >> gtObjectFor: aView [
	<gtView>
	<gtLlmView>
	^ aView explicit
		title: 'Object';
		priority: 9;
		stencil: [ | container |
			container := BrVerticalPane new.
			container matchParent
				addAptitude: (BrLayoutResizerAptitude new common: [ container children ]);
				background: container theme default appBackground;
				addChild: (value gtDefaultInspectorTool asElement
						margin: (BlInsets all: 10);
						background: container theme default contentBackground;
						addAptitude: BrShadowAptitude;
						vFitContentLimited;
						hMatchParent) ]
]

{ #category : #'gt-views' }
GtLStoredObject >> gtProvenanceCodeFor: aView [
	"How can I replay the Smalltalk evaluations that produced this value?"

	<gtView>
	| script |
	script := self provenanceScript.
	script ifEmpty: [ ^ aView empty ].
	^ self
		gtDo: [ aView explicit
				title: 'Provenance code';
				priority: 11;
				stencil: [ | coder viewModel sharedBindings |
					coder := GtPharoSnippetCoder forSource: script.
					coder subscribeToSystem.
					viewModel := coder asCoderViewModel.
					sharedBindings := GtSharedVariablesBindings new.
					(sharedBindings bindingOf: #objectStorage) value: objectStorage.
					viewModel sharedBindings: sharedBindings.
					viewModel asExpandedOnlyElement vFitContentLimited ] ]
		gemstoneDo: [ aView text
				title: 'Provenance code';
				priority: 11;
				text: [ script asRopedText glamorousCodeFont ] ]
]

{ #category : #'gt-views' }
GtLStoredObject >> gtProvenanceFor: aView [
	"Which tool call produced this value, and where did each of its inputs come from?"

	<gtView>
	^ aView columnedTree
		title: 'Provenance';
		priority: 10;
		items: [ {self provenanceTree} ];
		children: [ :each | each children ];
		column: 'Entry' text: [ :each | each label ];
		column: 'Details' text: [ :each | each detail ];
		expandUpTo: 2;
		send: [ :each | each target ]
]

{ #category : #'gt extensions' }
GtLStoredObject >> gtViewsInContext: aPhlowContext [
	| collectedViews |
	collectedViews := Array
		streamContents: [ :aStream |
			aStream nextPutAll: (super gtViewsInContext: aPhlowContext).
			self gtInspectorTargetModels do: [ :eachTargetModel |
				aStream nextPutAll: (GtPhlowViewsCollector new
					fromObject: eachTargetModel;
					pragmaNames: GtLSettings messageViewPragmaNames;
					context: aPhlowContext;
					collect) ] ].

	GtPhlowUtility sortByPriority: collectedViews.

	^ collectedViews
]

{ #category : #accessing }
GtLStoredObject >> id [
	^ id
]

{ #category : #accessing }
GtLStoredObject >> idString36 [
	^ id asString36
]

{ #category : #'instance creation' }
GtLStoredObject >> initializeWithId: anId value: anObject reason: aReason [
	self
		assert: (aReason isKindOf: GtLStoredObjectReason)
		description: 'Expected a stored object reason'.
	id := anId.
	value := anObject.
	reason := aReason.
	^ self
]

{ #category : #accessing }
GtLStoredObject >> objectStorage: aStorage [
	objectStorage := aStorage
]

{ #category : #printing }
GtLStoredObject >> printOn: aStream [
	super printOn: aStream.
	aStream
		<< ' [';
		<< self idString36;
		<< '] ';
		print: value.
	reason
		ifNotNil: [ aStream
				<< ' (';
				<< reason asReasonString;
				<< ')' ]
]

{ #category : #'private - provenance' }
GtLStoredObject >> provenanceBindingNode: aBinding visited: aPath [
	| bindingName bindingId |
	bindingName := aBinding name ifNil: [ '' ].
	bindingName ifEmpty: [ bindingName := 'Unnamed binding' ].
	bindingId := aBinding objectId.
	objectStorage
		ifNotNil: [ objectStorage
				storedObjectAt: bindingId
				ifPresent: [ :aStoredObject | ^ aStoredObject provenanceNodeLabeled: bindingName visited: aPath ]
				ifAbsent: [  ] ].
	^ GtLStoredObjectProvenanceNode
		label: bindingName
		detail: 'Unavailable object: ' , bindingId asString
		target: aBinding
		children: #()
]

{ #category : #'private - provenance' }
GtLStoredObject >> provenanceNodeLabeled: aLabel visited: aPath [
	| aToolCall children |
	(aPath includes: self)
		ifTrue: [ ^ GtLStoredObjectProvenanceNode
				label: aLabel , ' (cycle)'
				detail: self storedValue
				target: self
				children: #() ].
	aToolCall := self reason provenanceToolCall.
	children := aToolCall
			ifNil: [ #() ]
			ifNotNil: [ {self provenanceToolCallNode: aToolCall visited: (aPath copyWith: self)} ].
	^ GtLStoredObjectProvenanceNode
		label: aLabel
		detail: self storedValue
		target: self
		children: children
]

{ #category : #provenance }
GtLStoredObject >> provenanceScript [
	^ GtLProvenanceCodeGenerator new scriptForTree: self provenanceTree
]

{ #category : #'private - provenance' }
GtLStoredObject >> provenanceToolCallNode: aToolCall visited: aPath [
	| toolName |
	toolName := aToolCall name
			ifNil: [ aToolCall tool ifNotNil: [ :aTool | aTool name ] ].
	^ GtLStoredObjectProvenanceNode
		label: (toolName ifNil: [ 'Tool call' ])
		detail: reason asReasonString
		target: aToolCall
		children: (reason provenanceBindings
				collect: [ :each | self provenanceBindingNode: each visited: aPath ])
]

{ #category : #provenance }
GtLStoredObject >> provenanceTree [
	^ self provenanceNodeLabeled: 'Result' visited: #()
]

{ #category : #accessing }
GtLStoredObject >> reason [
	^ reason
]

{ #category : #accessing }
GtLStoredObject >> storedValue [
	^ value
]

{ #category : #deprecated }
GtLStoredObject >> value [
	self
		deprecated: 'Use #storedValue to access the stored payload.'
		transformWith: '`@receiver value' -> '`@receiver storedValue'.
	^ self storedValue
]
