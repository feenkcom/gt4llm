Class {
	#name : #GtLClassChangeBlueprint,
	#superclass : #BrStencil,
	#instVars : [
		'classHistory',
		'methodHistories',
		'variableHistories',
		'nodeStatuses',
		'relationshipStatuses',
		'methodNodes'
	],
	#category : #'Gt4LlmCore-Summaries'
}

{ #category : #'instance creation' }
GtLClassChangeBlueprint class >> on: aClassHistory [
	^ self new classHistory: aClassHistory
]

{ #category : #private }
GtLClassChangeBlueprint >> addRelationshipsOf: aMethod source: aSource methods: someMethods variables: someVariables to: someRelationships [
	| ast classSide slotType |
	ast := self parseMethodSource: aSource.
	ast ifNil: [ ^ self ].
	classSide := self isClassSideMethodFor: aMethod.
	slotType := classSide
			ifTrue: [ GtLClassSlotType uniqueInstance ]
			ifFalse: [ GtLInstanceSlotType uniqueInstance ].
	ast
		allNodesDo: [ :aNode | 
			aNode isVariable
				ifTrue: [ aNode isLocallyDefined
						ifFalse: [ | variableName target |
							variableName := aNode variableName.
							target := someVariables
									at: {slotType.
											variableName}
									ifAbsent: [ someVariables
											at: {GtLClassVariableType uniqueInstance.
													variableName}
											ifAbsent: [ nil ] ].
							target
								ifNotNil: [ someRelationships
										add: {aMethod.
												target} ] ] ].
			self
				selectorsSentToSelfBy: aNode
				do: [ :aSelector | 
					someMethods
						at: {classSide.
								aSelector}
						ifPresent: [ :target | 
							someRelationships
								add: {aMethod.
										target} ] ] ]
]

{ #category : #rendering }
GtLClassChangeBlueprint >> backgroundColorForStatus: aStatus in: aStatusTheme [
	aStatus = #added ifTrue: [ ^ aStatusTheme successBackgroundColor ].
	aStatus = #removed ifTrue: [ ^ aStatusTheme errorBackgroundColor ].
	aStatus = #changed ifTrue: [ ^ aStatusTheme failureBackgroundColor ].
	^ aStatusTheme neutralBackgroundColor
]

{ #category : #rendering }
GtLClassChangeBlueprint >> blueprintLabel: aString size: aNumber [
	| label |
	label := BrLabel new.
	^ label
		text: aString;
		aptitude: (BrGlamorousLabelAptitude new
				fontSize: aNumber;
				foreground: label theme header disabledTextColor);
		fitContent
]

{ #category : #rendering }
GtLClassChangeBlueprint >> borderColorForStatus: aStatus in: aStatusTheme [
	aStatus = #added ifTrue: [ ^ aStatusTheme successBorderColor ].
	aStatus = #removed ifTrue: [ ^ aStatusTheme errorBorderColor ].
	aStatus = #changed ifTrue: [ ^ aStatusTheme failureBorderColor ].
	^ aStatusTheme neutralBorderColor
]

{ #category : #accessing }
GtLClassChangeBlueprint >> classHistory [
	^ classHistory
]

{ #category : #accessing }
GtLClassChangeBlueprint >> classHistory: aClassHistory [
	classHistory := aClassHistory.
	methodHistories := nil.
	methodNodes := nil.
	variableHistories := nil.
	nodeStatuses := nil.
	relationshipStatuses := nil
]

{ #category : #private }
GtLClassChangeBlueprint >> computeMethodNodes [
	| trackedMethods definitionHistory className |
	trackedMethods := self methodHistories.
	definitionHistory := self classHistory behaviourChangeHistory.
	(definitionHistory isInitialChangeAddition
		or: [ definitionHistory isLatestChangeRemoval ]) ifTrue: [ ^ trackedMethods ].
	className := self classHistory targetClassName.
	className ifNil: [ ^ trackedMethods ].
	className
		asClassIfPresent: [ :aClass | 
			| trackedKeys currentMethods |
			trackedKeys := trackedMethods
					collectAsSet: [ :aMethod | self methodKeyFor: aMethod ].
			currentMethods := aClass instanceSide methods , aClass classSide methods.
			^ trackedMethods
				, (currentMethods
						reject: [ :aMethod | trackedKeys includes: (self methodKeyFor: aMethod) ]) ].
	^ trackedMethods
]

{ #category : #private }
GtLClassChangeBlueprint >> computeNodeStatuses [
	| statuses |
	statuses := Dictionary new.
	self methodNodes
		do: [ :aMethod | 
			statuses
				at: aMethod
				put: (aMethod isCompiledMethod
						ifTrue: [ #unchanged ]
						ifFalse: [ self nodeStatusForHistory: aMethod ]) ].
	self variableHistories
		do: [ :aHistory | statuses at: aHistory put: (self nodeStatusForHistory: aHistory) ].
	^ statuses
]

{ #category : #private }
GtLClassChangeBlueprint >> computeRelationshipStatuses [
	| before after statuses |
	before := self relationshipsBefore: true.
	after := self relationshipsBefore: false.
	statuses := Dictionary new.
	before
		do: [ :aRelationship | 
			statuses
				at: aRelationship
				put: ((after includes: aRelationship) ifTrue: [ #unchanged ] ifFalse: [ #removed ]) ].
	after
		do: [ :aRelationship | statuses at: aRelationship ifAbsentPut: [ #added ] ].
	^ statuses
]

{ #category : #rendering }
GtLClassChangeBlueprint >> create [
	| container elements |
	container := BrVerticalPane new
			fitContent;
			clipChildren: false;
			padding: (BlInsets all: 10);
			cellSpacing: 8.
	container background: container theme default contentBackground.
	container addChild: self titleElement.
	elements := IdentityDictionary new.
	self methodNodes
		do: [ :method | 
			elements
				at: method
				put: (self nodeElementFor: method label: (self methodSelectorFor: method) asString) ].
	self variableHistories
		do: [ :history | 
			elements
				at: history
				put: (self nodeElementFor: history label: (self labelForVariable: history)) ].
	container addChild: (self createLayerGridWith: elements).
	self relationshipStatuses
		keysAndValuesDo: [ :relationship :status | 
			| source target line |
			source := elements at: relationship first.
			target := elements at: relationship second.
			(source ~~ target
				and: [ source parent == target parent and: [ status ~= #removed ] ])
				ifTrue: [ source graph connectTo: target ].
			line := self
					dependencyLineFrom: source
					to: target
					status: status.
			line graph model: relationship.
			container addChild: line ].
	^ container
]

{ #category : #building }
GtLClassChangeBlueprint >> createLayerGridWith: elements [
	| grid layers methodGroups variableGroups methodLayers |
	layers := {#initializers -> 'Initializers'.
			#interface -> 'Interface'.
			#internal -> 'Internal'.
			#accessors -> 'Accessors'.
			#variables -> 'Variables'}.
	grid := BlElement new
			constraintsDo: [ :c | 
				c horizontal fitContent.
				c vertical fitContent.
				c linear horizontal alignCenter ];
			clipChildren: false;
			layout: (BlGridLayout horizontal
					columnCount: layers size + 1;
					cellSpacing: 5).
	grid addChild: (BlElement new size: 0 @ 0).
	layers do: [ :layer | grid addChild: (self layerHeading: layer value) ].
	methodGroups := self methodNodes
			groupedBy: [ :method | self isClassSideMethodFor: method ].
	variableGroups := self variableHistories
			groupedBy: [ :history | history variableType ~= GtLInstanceSlotType uniqueInstance ].
	methodLayers := self methodLayers.
	{false -> 'Instance'.
		true -> 'Class'}
		do: [ :side | 
			| methods variables sideMethodGroups |
			methods := methodGroups at: side key ifAbsent: [ #() ].
			variables := variableGroups at: side key ifAbsent: [ #() ].
			(methods isNotEmpty or: [ variables isNotEmpty ])
				ifTrue: [ sideMethodGroups := methods groupedBy: [ :method | methodLayers at: method ].
					grid addChild: (self sideHeading: side value).
					layers
						do: [ :layer | 
							| nodes |
							nodes := layer key = #variables
									ifTrue: [ variables ]
									ifFalse: [ sideMethodGroups at: layer key ifAbsent: [ #() ] ].
							grid
								addChild: (self createLayerWithNodes: (nodes collect: [ :node | elements at: node ])) ] ] ].
	^ grid
]

{ #category : #building }
GtLClassChangeBlueprint >> createLayerWithNodes: nodes [
	| contents |
	contents := self layerContentsContainer.
	nodes do: [ :node | contents addChild: node ].
	^ contents
		when: BlClickEvent
		do: [ :event | 
			event target phlow spawnObject: (nodes collect: [ :node | node graph model ]).
			event consumed: true ]
]

{ #category : #rendering }
GtLClassChangeBlueprint >> dependencyLineFrom: aSource to: aTarget status: aStatus [
	| line statusTheme |
	line := aSource == aTarget
			ifTrue: [ self recursiveLineOn: aSource ]
			ifFalse: [ BlParabollaArcElement new
					curvatureFraction: 0.05;
					fromAnchor: (BlElementCenterRightAnchor referenceElement: aSource relatedTo: aTarget);
					toAnchor: (BlElementCenterLeftAnchor referenceElement: aTarget relatedTo: aSource) ].
	statusTheme := line theme status.
	line
		zIndex: -1;
		constraintsDo: [ :constraints | constraints ignoreByLayout ];
		border: (aStatus = #unchanged
				ifTrue: [ statusTheme neutralBackgroundColor ]
				ifFalse: [ self borderColorForStatus: aStatus in: statusTheme ]).
	line userData at: #blueprintStatus put: aStatus.
	^ line
]

{ #category : #'gt - extensions' }
GtLClassChangeBlueprint >> gtLiveFor: aView [
	<gtView>
	classHistory ifNil: [ ^ aView empty ].
	^ aView canvassable
		title: 'Live';
		priority: 0;
		question: 'How did the methods, variables, and relationships change?';
		stencil: [ self ]
]

{ #category : #private }
GtLClassChangeBlueprint >> initialLayerFor: aMethod [
	| source |
	((self methodSelectorFor: aMethod) asString beginsWith: 'initialize')
		ifTrue: [ ^ #initializers ].
	source := (self methodSourceFor: aMethod before: false)
			ifNil: [ (self methodSourceFor: aMethod before: true)
					ifNil: [ aMethod latestChange changeResult oldStateMethodSourceCode ] ].
	(self isAccessorAst: (self parseMethodSource: source)) ifTrue: [ ^ #accessors ].
	^ #interface
]

{ #category : #private }
GtLClassChangeBlueprint >> isAccessorAst: aMethodNode [
	| statements statement expression |
	(aMethodNode isNil or: [ aMethodNode isMethod not ]) ifTrue: [ ^ false ].
	statements := aMethodNode body statements.
	statements size = 1 ifFalse: [ ^ false ].
	statement := statements first.
	statement isErrorNode ifTrue: [ ^ false ].
	expression := statement isReturn
			ifTrue: [ statement value ]
			ifFalse: [ statement ].
	expression ifNil: [ ^ false ].
	expression isAssignment
		ifTrue: [ ^ aMethodNode numArgs = 1
				and: [ (self isFreeSlotReference: expression variable)
						and: [ expression value isVariable
								and: [ expression value variableName = aMethodNode argumentNames first ] ] ] ].
	statement isReturn ifFalse: [ ^ false ].
	^ (self isFreeSlotReference: expression)
		or: [ expression isMessageSend
				and: [ expression selector = #ifNil:
						and: [ self isFreeSlotReference: expression receiver ] ] ]
]

{ #category : #accessing }
GtLClassChangeBlueprint >> isClassSideMethodFor: aMethodNode [
	^ aMethodNode isCompiledMethod
		ifTrue: [ aMethodNode methodClass isClassSide ]
		ifFalse: [ aMethodNode methodReference isClassSide ]
]

{ #category : #private }
GtLClassChangeBlueprint >> isFreeSlotReference: aNode [
	^ aNode notNil
		and: [ aNode isVariable
				and: [ aNode isLocallyDefined not
						and: [ aNode isSpecialVariable not and: [ aNode variableName first isLowercase ] ] ] ]
]

{ #category : #rendering }
GtLClassChangeBlueprint >> labelForVariable: aHistory [
	aHistory variableType = GtLClassVariableType uniqueInstance
		ifTrue: [ ^ aHistory variableName asString , ' (class variable)' ].
	^ aHistory variableName asString
]

{ #category : #rendering }
GtLClassChangeBlueprint >> layerContentsContainer [
	^ BlElement new
		clipChildren: false;
		padding: (BlInsets all: 5);
		constraintsDo: [ :c | 
			c vertical fitContent.
			c horizontal fitContent.
			c grid horizontal alignCenter.
			c grid vertical alignTop ];
		layout: (BlOnceLayout
				on: (GtGradHorizontalDominanceTreeLayout new
						treesDistance: 10;
						levelDistance: 10;
						nodeDistance: 5))
]

{ #category : #building }
GtLClassChangeBlueprint >> layerHeading: aString [
	^ (self blueprintLabel: aString size: 8)
		constraintsDo: [ :c | c grid horizontal alignCenter ]
]

{ #category : #accessing }
GtLClassChangeBlueprint >> methodHistories [
	^ methodHistories
		ifNil: [ methodHistories := self classHistory methodHistories items asArray ]
]

{ #category : #private }
GtLClassChangeBlueprint >> methodKeyFor: aMethodNode [
	^ {self isClassSideMethodFor: aMethodNode.
		self methodSelectorFor: aMethodNode}
]

{ #category : #accessing }
GtLClassChangeBlueprint >> methodLayers [
	| layers |
	layers := IdentityDictionary new.
	self methodNodes
		do: [ :aMethod | layers at: aMethod put: (self initialLayerFor: aMethod) ].
	self relationshipStatuses
		keysDo: [ :aRelationship | 
			| sourceLayer target |
			sourceLayer := layers at: aRelationship first.
			target := aRelationship second.
			((#(#interface #internal) includes: sourceLayer)
				and: [ (layers at: target ifAbsent: [ nil ]) = #interface ])
				ifTrue: [ layers at: target put: #internal ] ].
	^ layers
]

{ #category : #accessing }
GtLClassChangeBlueprint >> methodNodes [
	^ methodNodes ifNil: [ methodNodes := self computeMethodNodes ]
]

{ #category : #accessing }
GtLClassChangeBlueprint >> methodSelectorFor: aMethodNode [
	^ aMethodNode isCompiledMethod
		ifTrue: [ aMethodNode selector ]
		ifFalse: [ aMethodNode methodReference methodName asSymbol ]
]

{ #category : #private }
GtLClassChangeBlueprint >> methodSourceFor: aMethod before: aBoolean [
	| source |
	aMethod isCompiledMethod ifTrue: [ ^ aMethod sourceCode ifNil: [ '' ] ].
	aBoolean
		ifTrue: [ aMethod isInitialChangeAddition ifTrue: [ ^ nil ].
			source := aMethod initialChange changeResult oldStateMethodSourceCode ]
		ifFalse: [ aMethod isLatestChangeRemoval ifTrue: [ ^ nil ].
			source := aMethod latestChange changeResult newStateMethodSourceCode ].
	^ source ifNil: [ '' ]
]

{ #category : #rendering }
GtLClassChangeBlueprint >> nodeElementFor: aNodeModel label: aString [
	| element status |
	status := self nodeStatuses at: aNodeModel.
	element := BlElement new
			size: 10 @ 10;
			addEventHandler: BlPullHandler new;
			addAptitude: (BrGlamorousWithExplicitTooltipAptitude
					text: aString , ' (' , status asString , ')');
			when: BlClickEvent
				do: [ :event | 
					event target phlow spawnObject: aNodeModel.
					event consumed: true ].
	self style: element forStatus: status.
	element graph
		beNode;
		model: aNodeModel.
	^ element
]

{ #category : #'private - model' }
GtLClassChangeBlueprint >> nodeStatusForHistory: aHistory [
	| latestChange |
	aHistory hasNoEffect ifTrue: [ ^ #unchanged ].
	aHistory isLatestChangeRemoval ifTrue: [ ^ #removed ].
	aHistory isInitialChangeAddition ifTrue: [ ^ #added ].
	latestChange := aHistory latestChange.
	(latestChange isMethodAdditionResult
		or: [ latestChange isVariableAdditionResult ]) ifTrue: [ ^ #added ].
	^ #changed
]

{ #category : #accessing }
GtLClassChangeBlueprint >> nodeStatuses [
	^ nodeStatuses ifNil: [ nodeStatuses := self computeNodeStatuses ]
]

{ #category : #private }
GtLClassChangeBlueprint >> parseMethodSource: aSource [
	(aSource isNil or: [ aSource isEmpty ]) ifTrue: [ ^ nil ].
	^ GtPharoParser
		parseWithErrors: aSource
		startingAt: GtPharoParser startingStateForMethod
]

{ #category : #rendering }
GtLClassChangeBlueprint >> recursiveLineOn: aNode [
	| start finish control |
	start := BlElementTopRightAnchor element: aNode.
	finish := BlElementBottomRightAnchor element: aNode.
	control := (BlPerpendicularAnchor curvature: 18)
			referenceAnchors: {start.
					finish}.
	^ BlBezierElement new
		fromAnchor: start;
		toAnchor: finish;
		viaAnchor: control
]

{ #category : #accessing }
GtLClassChangeBlueprint >> relationshipStatuses [
	^ relationshipStatuses
		ifNil: [ relationshipStatuses := self computeRelationshipStatuses ]
]

{ #category : #private }
GtLClassChangeBlueprint >> relationshipsBefore: aBoolean [
	| methodSources methods variables relationships |
	methodSources := IdentityDictionary new.
	methods := Dictionary new.
	self methodNodes
		do: [ :aMethod | 
			(self methodSourceFor: aMethod before: aBoolean)
				ifNotNil: [ :aSource | 
					methods at: (self methodKeyFor: aMethod) put: aMethod.
					methodSources at: aMethod put: aSource ] ].
	variables := Dictionary new.
	self variableHistories
		do: [ :aHistory | 
			(self variableHistoryFor: aHistory before: aBoolean)
				ifNotNil: [ variables
						at: {aHistory variableType.
								aHistory variableName asSymbol}
						put: aHistory ] ].
	relationships := Set new.
	methodSources
		keysAndValuesDo: [ :aMethod :aSource | 
			self
				addRelationshipsOf: aMethod
				source: aSource
				methods: methods
				variables: variables
				to: relationships ].
	^ relationships
]

{ #category : #private }
GtLClassChangeBlueprint >> selectorsSentToSelfBy: aNode do: aBlock [
	aNode isMessageSend
		ifTrue: [ aNode receiver
				ifNotNil: [ :aReceiver | aReceiver isSelf ifTrue: [ aBlock value: aNode selector ] ] ].
	aNode isCascade
		ifTrue: [ aNode receiver
				ifNotNil: [ :aReceiver | 
					aReceiver isSelf
						ifTrue: [ aNode messages do: [ :aMessage | aBlock value: aMessage selector ] ] ] ]
]

{ #category : #building }
GtLClassChangeBlueprint >> sideHeading: aString [
	^ BrFrame new
		fitContent;
		constraintsDo: [ :c | 
			c grid horizontal alignCenter.
			c grid vertical alignCenter ];
		addChild: ((self blueprintLabel: aString size: 8)
				constraintsDo: [ :c | c accountTransformation ];
				transformDo: [ :transformation | transformation rotateBy: -90 ])
]

{ #category : #rendering }
GtLClassChangeBlueprint >> style: anElement forStatus: aStatus [
	| theme |
	theme := anElement theme status.
	anElement
		background: (self backgroundColorForStatus: aStatus in: theme);
		border: (self borderColorForStatus: aStatus in: theme).
	anElement userData at: #blueprintStatus put: aStatus
]

{ #category : #rendering }
GtLClassChangeBlueprint >> titleElement [
	^ BrLabel new
		text: self classHistory targetClassName asString;
		aptitude: BrGlamorousLabelAptitude new;
		fitContent;
		constraintsDo: [ :c | c linear horizontal alignCenter ];
		when: BlClickEvent
			do: [ :event | 
				event target phlow spawnObject: self classHistory.
				event consumed: true ]
]

{ #category : #accessing }
GtLClassChangeBlueprint >> variableHistories [
	^ variableHistories
		ifNil: [ variableHistories := self classHistory variableChangeHistories items asArray ]
]

{ #category : #private }
GtLClassChangeBlueprint >> variableHistoryFor: aHistory before: aBoolean [
	| isAbsent |
	isAbsent := aBoolean
			ifTrue: [ aHistory isInitialChangeAddition ]
			ifFalse: [ aHistory isLatestChangeRemoval ].
	^ isAbsent ifFalse: [ aHistory ]
]
