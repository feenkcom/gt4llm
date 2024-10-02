Class {
	#name : #GtLlmActionTemplateElement,
	#superclass : #BrVerticalPane,
	#instVars : [
		'codeEditor',
		'tutorNameAttribute',
		'priorityAttribute',
		'descriptionAttribute',
		'actionNameAttribute',
		'toolbar',
		'example',
		'onActionCreated'
	],
	#category : #'Gt4Llm-Widgets'
}

{ #category : #accessing }
GtLlmActionTemplateElement >> codeEditor [
	^ codeEditor
]

{ #category : #accessing }
GtLlmActionTemplateElement >> codeEditor: anObject [
	codeEditor := anObject
]

{ #category : #'as yet unclassified' }
GtLlmActionTemplateElement >> createAction [
	| action |
	action := 'gt' , actionNameAttribute string
			, '
 	<gtLlmTutorAction>
 	^ GtLlmTutorAction new
	    name: ''' , tutorNameAttribute string
			, ''';
	    priority: ' , priorityAttribute string
			, ';
		description: ''' , descriptionAttribute string
			, ''';
		examples: {GtLlmTutorActionExample new
	input: { ' , (self finalExampleStringFor: self example input)
			, ' } asDictionary;
	output: { ' , (self finalExampleStringFor: self example output)
			, ' } asDictionary}'.
	self onActionCreated value: action
]

{ #category : #'as yet unclassified' }
GtLlmActionTemplateElement >> descriptionString [
	^ (self example input at: 'Action') copyReplaceAll: 'Chat request: ' with: ''
]

{ #category : #accessing }
GtLlmActionTemplateElement >> example [
	^ example
]

{ #category : #accessing }
GtLlmActionTemplateElement >> example: anObject [
	example := anObject.
	self onExampleUpdated
]

{ #category : #'as yet unclassified' }
GtLlmActionTemplateElement >> exampleStringFor: anObject [
	| all finalRope |
	all := anObject associations
			collect: [ :aPair | 
				aPair key = 'Action'
					ifTrue: [ '''Action'' -> ''' asRopedText , tutorNameAttribute codeEditor
							, '''' asRopedText ]
					ifFalse: [ (aPair key storeString , ' -> '
							, (aPair value ifNil: [ 'nil' ] ifNotNil: #storeString)) asRopedText ] ]
			separatedBy: '. ' asRopedText.

	finalRope := '' asRopedText.

	all do: [ :aRope | finalRope := finalRope , aRope ].

	^ finalRope
]

{ #category : #'as yet unclassified' }
GtLlmActionTemplateElement >> finalExampleStringFor: anObject [
	| all finalRope |
	all := anObject associations
			collect: [ :aPair | 
				aPair key = 'Action'
					ifTrue: [ '''Action'' -> ''' asRopedText , tutorNameAttribute string
							, '''' asRopedText ]
					ifFalse: [ (aPair key storeString , ' -> '
							, (aPair value ifNil: [ 'nil' ] ifNotNil: #storeString)) asRopedText ] ]
			separatedBy: '. ' asRopedText.

	finalRope := '' asRopedText.

	all do: [ :aRope | finalRope := finalRope , aRope ].

	^ finalRope
]

{ #category : #'as yet unclassified' }
GtLlmActionTemplateElement >> initialize [
	super initialize.
	
	self fitContent.
	
	self initializeCodeEditor.
	self initializeToolbar.
	
	self addChild: self codeEditor as: #codeEditor.
	self addChild: self toolbar as: #toolbar.
]

{ #category : #'as yet unclassified' }
GtLlmActionTemplateElement >> initializeCodeEditor [
	codeEditor := BrEditor new beReadOnlyWithSelection
			size: 400@400;
			aptitude: BrGlamorousCodeEditorAptitude
]

{ #category : #'as yet unclassified' }
GtLlmActionTemplateElement >> initializeToolbar [
	toolbar := BrToolbar new fitContent
			aptitude: BrGlamorousToolbarAptitude;
			addChild: (BrButton new
					aptitude: BrGlamorousButtonWithIconAptitude;
					label: 'Accept';
					icon: BrGlamorousVectorIcons accept;
					action: [ self createAction ])
]

{ #category : #accessing }
GtLlmActionTemplateElement >> onActionCreated [
	^ onActionCreated
]

{ #category : #accessing }
GtLlmActionTemplateElement >> onActionCreated: anObject [
	onActionCreated := anObject
]

{ #category : #accessing }
GtLlmActionTemplateElement >> onExampleUpdated [
	codeEditor text: self templatedText
]

{ #category : #'as yet unclassified' }
GtLlmActionTemplateElement >> templatedText [
	| template |
	tutorNameAttribute := GtSharedStringAttributeBuilder new string: 'Action name'.

	priorityAttribute := GtSharedStringAttributeBuilder new string: '10'.
	descriptionAttribute := GtSharedStringAttributeBuilder new
			string: self descriptionString.
	actionNameAttribute := GtSharedStringAttributeBuilder new string: 'ACTIONNAME'.

	template := 'gt' asRopedText , actionNameAttribute codeEditor
			, '
 	<gtLlmTutorAction>
 	^ GtLlmTutorAction new
	    name: ''' asRopedText , tutorNameAttribute codeEditor
			, ''';
	    priority: ' asRopedText , priorityAttribute codeEditor
			, ';
		description: ''' asRopedText , descriptionAttribute codeEditor
			, ''';
		examples: {GtLlmTutorActionExample new
	input: { ' asRopedText , (self exampleStringFor: self example input)
			, ' } asDictionary;
	output: { ' asRopedText , (self exampleStringFor: self example output)
			, ' } asDictionary}' asRopedText.

	^ ((GtCompositeSmaCCASTStyler forParser: GtPharoParser)
		stylers: {GtSmaCCPharoStyler new.
				GtPharoDynamicHighlightStyler new}) style: template
]

{ #category : #accessing }
GtLlmActionTemplateElement >> toolbar [
	^ toolbar
]

{ #category : #accessing }
GtLlmActionTemplateElement >> toolbar: anObject [
	toolbar := anObject
]
