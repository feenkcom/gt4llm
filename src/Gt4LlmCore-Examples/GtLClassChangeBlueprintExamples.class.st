Class {
	#name : #GtLClassChangeBlueprintExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Summarizers'
}

{ #category : #'private - setup' }
GtLClassChangeBlueprintExamples >> addMethod: aSelector classSide: isClassSide versions: someSources to: aClassHistory [
	| reference methodHistory |
	reference := GtLMethodReference new
			methodClassName: aClassHistory targetClassName;
			methodName: aSelector;
			classSide: isClassSide;
			yourself.
	methodHistory := GtLMethodChangeHistory new methodReference: reference.
	1
		to: someSources size - 1
		do: [ :index | 
			methodHistory
				addChange: (self
						codeChange: (self
								methodChangeFrom: (someSources at: index)
								to: (someSources at: index + 1)
								reference: reference)) ].
	aClassHistory addMethodHistory: methodHistory
]

{ #category : #examples }
GtLClassChangeBlueprintExamples >> blueprint [
	<gtExample>
	<return: #GtLClassChangeBlueprint>
	| blueprint expected |
	blueprint := GtLClassChangeBlueprint on: self classHistory.
	expected := Dictionary
			newFrom: {(self
						methodNamed: #caller
						classSide: false
						in: blueprint) -> #changed.
					(self
						methodNamed: #kept
						classSide: false
						in: blueprint) -> #changed.
					(self
						methodNamed: #erased
						classSide: false
						in: blueprint) -> #removed.
					(self
						methodNamed: #fresh
						classSide: false
						in: blueprint) -> #added.
					(self
						methodNamed: #temporary
						classSide: false
						in: blueprint) -> #unchanged.
					(self
						methodNamed: #caller
						classSide: true
						in: blueprint) -> #changed.
					(self
						methodNamed: #kept
						classSide: true
						in: blueprint) -> #changed.
					(self
						methodNamed: #shadow
						classSide: true
						in: blueprint) -> #added.
					(self
						variableNamed: #removedSlot
						type: GtLInstanceSlotType
						in: blueprint) -> #removed.
					(self
						variableNamed: #movedSlot
						type: GtLInstanceSlotType
						in: blueprint) -> #removed.
					(self
						variableNamed: #addedSlot
						type: GtLInstanceSlotType
						in: blueprint) -> #added.
					(self
						variableNamed: #movedSlot
						type: GtLClassSlotType
						in: blueprint) -> #added.
					(self
						variableNamed: #SharedValue
						type: GtLClassVariableType
						in: blueprint) -> #added}.
	self assert: blueprint nodeStatuses equals: expected.
	^ blueprint
]

{ #category : #examples }
GtLClassChangeBlueprintExamples >> blueprintView [
	<gtExample>
	<return: #GtPhlowCanvassableView>
	| history view emptyHistory |
	history := self classHistory.
	view := history gtClassBlueprintFor: GtPhlowView empty.
	self assert: (view isKindOf: GtPhlowCanvassableView).
	self assert: view title equals: 'Class Blueprint'.
	self assert: view stencilBuilder build classHistory == history.
	emptyHistory := GtLClassChangeHistory new targetClassName: self targetClassName.
	self
		assert: ((emptyHistory gtClassBlueprintFor: GtPhlowView empty)
				isKindOf: GtPhlowCanvassableView).
	^ view
]

{ #category : #examples }
GtLClassChangeBlueprintExamples >> blueprintWithRelationships [
	<gtExample>
	<return: #GtLClassChangeBlueprint>
	| blueprint caller kept erased fresh classCaller classKept removedSlot addedSlot oldMovedSlot newMovedSlot sharedVariable |
	blueprint := self blueprint.
	caller := self
			methodNamed: #caller
			classSide: false
			in: blueprint.
	kept := self
			methodNamed: #kept
			classSide: false
			in: blueprint.
	erased := self
			methodNamed: #erased
			classSide: false
			in: blueprint.
	fresh := self
			methodNamed: #fresh
			classSide: false
			in: blueprint.
	classCaller := self
			methodNamed: #caller
			classSide: true
			in: blueprint.
	classKept := self
			methodNamed: #kept
			classSide: true
			in: blueprint.
	removedSlot := self
			variableNamed: #removedSlot
			type: GtLInstanceSlotType
			in: blueprint.
	addedSlot := self
			variableNamed: #addedSlot
			type: GtLInstanceSlotType
			in: blueprint.
	oldMovedSlot := self
			variableNamed: #movedSlot
			type: GtLInstanceSlotType
			in: blueprint.
	newMovedSlot := self
			variableNamed: #movedSlot
			type: GtLClassSlotType
			in: blueprint.
	sharedVariable := self
			variableNamed: #SharedValue
			type: GtLClassVariableType
			in: blueprint.
	self
		assert: blueprint relationshipStatuses
		equals: (Dictionary
				newFrom: {{caller.
							kept} -> #unchanged.
						{caller.
							erased} -> #removed.
						{caller.
							fresh} -> #added.
						{caller.
							removedSlot} -> #removed.
						{caller.
							oldMovedSlot} -> #removed.
						{caller.
							addedSlot} -> #added.
						{caller.
							sharedVariable} -> #added.
						{erased.
							removedSlot} -> #removed.
						{fresh.
							addedSlot} -> #added.
						{fresh.
							fresh} -> #added.
						{classCaller.
							classKept} -> #removed.
						{classCaller.
							newMovedSlot} -> #added.
						{classCaller.
							sharedVariable} -> #added}).
	^ blueprint
]

{ #category : #examples }
GtLClassChangeBlueprintExamples >> blueprintWithUnchangedMethods [
	<gtExample>
	<return: #GtLClassChangeBlueprint>
	| history blueprint caller liveTarget added removed changed |
	history := GtLClassChangeHistory new targetClassName: GtClassBlueprint name.
	self
		addMethod: #widthOfMethod:
		classSide: false
		versions: {nil.
				(GtClassBlueprint >> #widthOfMethod:) sourceCode}
		to: history.
	self
		addMethod: #heightOfMethod:
		classSide: false
		versions: {(GtClassBlueprint >> #heightOfMethod:) sourceCode.
				nil}
		to: history.
	self
		addMethod: #minimumNodeSize
		classSide: false
		versions: {'minimumNodeSize ^ self colorForMethod: nil'.
				(GtClassBlueprint >> #minimumNodeSize) sourceCode}
		to: history.
	blueprint := GtLClassChangeBlueprint on: history.
	caller := GtClassBlueprint >> #createLayerForMethods:named:.
	liveTarget := GtClassBlueprint >> #colorForMethod:.
	added := self
			methodNamed: #widthOfMethod:
			classSide: false
			in: blueprint.
	removed := self
			methodNamed: #heightOfMethod:
			classSide: false
			in: blueprint.
	changed := self
			methodNamed: #minimumNodeSize
			classSide: false
			in: blueprint.
	self assert: blueprint methodHistories size equals: 3.
	self assert: (blueprint methodNodes includes: caller).
	self assert: (blueprint methodNodes includes: liveTarget).
	self
		assert: (blueprint methodNodes includes: GtClassBlueprint >> #heightOfMethod:) not.
	self assert: (blueprint nodeStatuses at: caller) equals: #unchanged.
	self assert: (blueprint nodeStatuses at: liveTarget) equals: #unchanged.
	self
		assert: (blueprint relationshipStatuses
				at: {caller.
						added})
		equals: #added.
	self
		assert: (blueprint relationshipStatuses
				at: {caller.
						removed})
		equals: #removed.
	self
		assert: (blueprint relationshipStatuses
				at: {caller.
						changed})
		equals: #unchanged.
	self
		assert: (blueprint relationshipStatuses
				at: {caller.
						liveTarget})
		equals: #unchanged.
	self
		assert: (blueprint relationshipStatuses
				at: {changed.
						liveTarget})
		equals: #removed.
	^ blueprint
]

{ #category : #examples }
GtLClassChangeBlueprintExamples >> classAdditionAndRemoval [
	<gtExample>
	<return: #Array>
	| definition addition removal addedBlueprint removedBlueprint nodeCount |
	definition := GtLClassDefinitionDescription fromClass: GtClassBlueprint.
	addition := GtLClassChangeHistory new
			targetClassName: definition currentClassName.
	addition
		addBehaviourChange: (self
				codeChange: (GtLClassModificationResult new
						updatedClass: definition;
						yourself)).
	self
		addMethod: #access
		classSide: false
		versions: {nil.
				'access ^ types'}
		to: addition.
	removal := GtLClassChangeHistory new
			targetClassName: definition currentClassName.
	removal
		addBehaviourChange: (self
				codeChange: (GtLClassRemovalResult new
						removedClass: definition;
						yourself)).
	self
		addMethod: #access
		classSide: false
		versions: {'access ^ types'.
				nil}
		to: removal.
	addedBlueprint := GtLClassChangeBlueprint on: addition.
	removedBlueprint := GtLClassChangeBlueprint on: removal.
	nodeCount := definition instanceSlotNames size + definition classSlotNames size
			+ definition classVariableNames size + 1.
	self assert: addedBlueprint nodeStatuses size equals: nodeCount.
	self
		assert: (addedBlueprint nodeStatuses values allSatisfy: [ :status | status = #added ]).
	self
		assert: addedBlueprint relationshipStatuses values asArray
		equals: #(added).
	self assert: removedBlueprint nodeStatuses size equals: nodeCount.
	self
		assert: (removedBlueprint nodeStatuses values
				allSatisfy: [ :status | status = #removed ]).
	self
		assert: removedBlueprint relationshipStatuses values asArray
		equals: #(removed).
	^ {addedBlueprint.
		removedBlueprint}
]

{ #category : #examples }
GtLClassChangeBlueprintExamples >> classHistory [
	<gtExample>
	<return: #GtLClassChangeHistory>
	| history before after |
	history := GtLClassChangeHistory new targetClassName: self targetClassName.
	before := self
			definitionWithInstanceSlots: #(removedSlot movedSlot)
			classSlots: #()
			classVariables: #().
	after := self
			definitionWithInstanceSlots: #(addedSlot)
			classSlots: #(movedSlot)
			classVariables: #(SharedValue).
	history
		addBehaviourChange: (self
				codeChange: (GtLClassModificationResult new
						originalClass: before;
						updatedClass: after;
						yourself)).
	self
		addMethod: #caller
		classSide: false
		versions: #('caller | addedSlot | addedSlot := 1. self kept; erased. ^ removedSlot + movedSlot + addedSlot' 'caller | movedSlot | movedSlot := 2. self kept; fresh. ^ addedSlot + SharedValue + movedSlot')
		to: history.
	self
		addMethod: #kept
		classSide: false
		versions: #('kept ^ 1' 'kept ^ 2' 'kept ^ 1')
		to: history.
	self
		addMethod: #erased
		classSide: false
		versions: {'erased ^ removedSlot'.
				nil}
		to: history.
	self
		addMethod: #fresh
		classSide: false
		versions: {nil.
				'fresh self fresh. ^ addedSlot'}
		to: history.
	self
		addMethod: #temporary
		classSide: false
		versions: {nil.
				'temporary ^ self kept'.
				nil}
		to: history.
	self
		addMethod: #caller
		classSide: true
		versions: #('caller ^ self kept' 'caller super kept. ^ movedSlot + SharedValue')
		to: history.
	self
		addMethod: #kept
		classSide: true
		versions: #('kept ^ 2' 'kept ^ 3')
		to: history.
	self
		addMethod: #shadow
		classSide: true
		versions: {nil.
				'shadow | movedSlot | movedSlot := 42. ^ movedSlot'}
		to: history.
	self assert: history methodHistories size equals: 8.
	self assert: history variableChangeHistories size equals: 5.
	^ history
]

{ #category : #examples }
GtLClassChangeBlueprintExamples >> clickBlueprintNodes [
	<gtExample>
	<return: #BlScripter>
	| blueprint element scripter spawned |
	blueprint := self blueprint.
	element := blueprint asElement.
	element
		when: GtPhlowObjectToSpawn
		do: [ :event | 
			spawned := event object.
			event consumed: true ].
	scripter := BlScripter new element: element.
	{self
			methodNamed: #caller
			classSide: false
			in: blueprint.
		self
			variableNamed: #movedSlot
			type: GtLClassSlotType
			in: blueprint}
		do: [ :history | 
			spawned := nil.
			scripter click
				onChildFromBlock: [ :root | 
					root withAllChildrenBreadthFirst
						detect: [ :child | child graph model == history ] ];
				play.
			self assert: spawned == history ].
	^ scripter
]

{ #category : #'private - setup' }
GtLClassChangeBlueprintExamples >> codeChange: aChangeResult [
	^ GtLSummarizerCodeChange new
		label: 'Example code change';
		changeResult: aChangeResult;
		yourself
]

{ #category : #'private - setup' }
GtLClassChangeBlueprintExamples >> definitionWithInstanceSlots: instanceSlotNames classSlots: classSlotNames classVariables: classVariableNames [
	^ GtLClassDefinitionDescription new
		currentClassName: self targetClassName;
		superclassName: 'Object';
		packageName: 'Gt4LlmCore-Examples';
		comment: '';
		instanceSlotNames: instanceSlotNames;
		classSlotNames: classSlotNames;
		classVariableNames: classVariableNames;
		traitCompositionString: '{}';
		yourself
]

{ #category : #'private - setup' }
GtLClassChangeBlueprintExamples >> methodChangeFrom: oldSource to: newSource reference: aMethodReference [
	| oldMethod |
	oldMethod := oldSource
			ifNotNil: [ self methodWithSource: oldSource reference: aMethodReference ].
	^ newSource
		ifNil: [ GtLMethodRemovalResult new
				removedMethod: oldMethod;
				status: 'removed';
				yourself ]
		ifNotNil: [ GtLMethodCompilationResult new
				oldMethod: oldMethod;
				newMethod: (self methodWithSource: newSource reference: aMethodReference);
				status: 'compiled';
				yourself ]
]

{ #category : #'private - accessing' }
GtLClassChangeBlueprintExamples >> methodNamed: aSelector classSide: isClassSide in: aBlueprint [
	^ aBlueprint methodHistories
		detect: [ :each | 
			each methodReference isClassSide = isClassSide
				and: [ each methodReference methodName asSymbol = aSelector ] ]
]

{ #category : #'private - setup' }
GtLClassChangeBlueprintExamples >> methodWithSource: aSource reference: aMethodReference [
	^ GtLMethodWithSource new
		methodReference: aMethodReference;
		sourceCode: aSource;
		yourself
]

{ #category : #examples }
GtLClassChangeBlueprintExamples >> renderedBlueprint [
	<gtExample>
	<return: #BlElement>
	| blueprint element holder nodeElements lines |
	blueprint := self blueprintWithRelationships.
	element := blueprint asElement.
	holder := BrVerticalPane new
			addChild: element;
			yourself.
	nodeElements := OrderedCollection new.
	element
		allChildrenBreadthFirstDo: [ :child | 
			(blueprint nodeStatuses includesKey: child graph model)
				ifTrue: [ nodeElements add: child ] ].
	lines := element children select: [ :child | child isKindOf: BlCurveElement ].
	self
		assert: (nodeElements collect: [ :node | node graph model ]) asBag
		equals: blueprint nodeStatuses keys asBag.
	self
		assert: (lines collect: [ :line | line graph model ]) asBag
		equals: blueprint relationshipStatuses keys asBag.
	{BrGlamorousLightTheme new.
		BrGlamorousDarkTheme new}
		do: [ :theme | 
			| statusTheme fills borders |
			holder theme: theme.
			statusTheme := theme status.
			fills := Dictionary
					newFrom: {#added -> statusTheme successBackgroundColor.
							#removed -> statusTheme errorBackgroundColor.
							#changed -> statusTheme failureBackgroundColor.
							#unchanged -> statusTheme neutralBackgroundColor}.
			borders := Dictionary
					newFrom: {#added -> statusTheme successBorderColor.
							#removed -> statusTheme errorBorderColor.
							#changed -> statusTheme failureBorderColor.
							#unchanged -> statusTheme neutralBorderColor}.
			nodeElements
				do: [ :node | 
					| status |
					status := blueprint nodeStatuses at: node graph model.
					self assert: (node userData at: #blueprintStatus) equals: status.
					self
						assert: (node background paint color blocResolveColorForTheme: node theme)
						equals: (fills at: status) rawColor.
					self
						assert: (node border paint color blocResolveColorForTheme: node theme)
						equals: (borders at: status) rawColor ].
			lines
				do: [ :line | 
					| relationship status lineColor |
					relationship := line graph model.
					status := blueprint relationshipStatuses at: relationship.
					lineColor := status = #unchanged
							ifTrue: [ statusTheme neutralBackgroundColor ]
							ifFalse: [ borders at: status ].
					self assert: (line userData at: #blueprintStatus) equals: status.
					self
						assert: line fromAnchor referenceElement graph model == relationship first.
					self
						assert: line toAnchor referenceElement graph model == relationship second.
					self
						assert: (line border paint color blocResolveColorForTheme: line theme)
						equals: lineColor rawColor ] ].
	element removeFromParent.
	^ element
]

{ #category : #examples }
GtLClassChangeBlueprintExamples >> renderedBlueprintWithUnchangedMethods [
	<gtExample>
	<return: #BlElement>
	| blueprint element caller callerNode expectedRelationships lines |
	blueprint := self blueprintWithUnchangedMethods.
	element := blueprint asElement.
	caller := GtClassBlueprint >> #createLayerForMethods:named:.
	callerNode := element withAllChildrenBreadthFirst
			detect: [ :each | each graph model == caller ].
	self assert: (callerNode userData at: #blueprintStatus) equals: #unchanged.
	expectedRelationships := blueprint relationshipStatuses keys
			select: [ :edge | edge first == caller ].
	lines := element children
			select: [ :each | 
				(each isKindOf: BlCurveElement)
					and: [ each fromAnchor referenceElement == callerNode ] ].
	self
		assert: (lines collect: [ :line | line graph model ]) asBag
		equals: expectedRelationships asBag.
	^ element
]

{ #category : #examples }
GtLClassChangeBlueprintExamples >> sharedLayerHeadings [
	<gtExample>
	<return: #BlElement>
	| element holder title grid cells headings sideHeadings |
	element := self blueprint asElement.
	holder := BrVerticalPane new
			addChild: element;
			yourself.
	title := element children first.
	grid := element children second.
	cells := grid children asArray.
	headings := cells copyFrom: 2 to: 6.
	sideHeadings := {(cells at: 7) children first.
			(cells at: 13) children first}.
	self
		assert: (element children reject: [ :child | child isKindOf: BlCurveElement ]) size
		equals: 2.
	self
		assert: (headings collect: [ :label | label text asString ])
		equals: #('Initializers' 'Interface' 'Internal' 'Accessors' 'Variables').
	self
		assert: (sideHeadings collect: [ :label | label text asString ])
		equals: #('Instance' 'Class').
	element forceLayout.
	self
		assert: (title position x + (title width / 2) - (grid position x + (grid width / 2)))
				abs < 0.01.
	sideHeadings
		do: [ :label | 
			| bounds |
			bounds := label bounds inParent bounds.
			self assert: (bounds width - label height) abs < 0.01.
			self assert: (bounds height - label width) abs < 0.01 ].
	self assert: (cells at: 7) position x equals: (cells at: 13) position x.
	2
		to: 6
		do: [ :column | 
			| heading centerX |
			heading := cells at: column.
			centerX := heading position x + (heading width / 2).
			#(6 12)
				do: [ :offset | 
					| cell cellCenterX |
					cell := cells at: column + offset.
					cellCenterX := cell position x + (cell width / 2).
					self assert: (centerX - cellCenterX) abs < 0.01 ] ].
	{BrGlamorousLightTheme new.
		BrGlamorousDarkTheme new}
		do: [ :theme | 
			holder theme: theme.
			headings , sideHeadings
				do: [ :heading | 
					| attributes fontSize foreground |
					attributes := heading text attributesAt: 1.
					fontSize := attributes
							detect: [ :attribute | attribute isKindOf: BlFontSizeAttribute ].
					self assert: fontSize size equals: 8.
					foreground := attributes
							detect: [ :attribute | attribute isKindOf: BlTextForegroundAttribute ].
					self
						assert: (foreground paint blocResolveColorForTheme: heading theme)
						equals: theme header disabledTextColor rawColor ] ].
	element removeFromParent.
	^ element
]

{ #category : #'private - setup' }
GtLClassChangeBlueprintExamples >> targetClassName [
	^ 'GtLClassChangeBlueprintExampleTarget'
]

{ #category : #'private - accessing' }
GtLClassChangeBlueprintExamples >> variableNamed: aName type: aVariableTypeClass in: aBlueprint [
	^ aBlueprint variableHistories
		detect: [ :each | 
			each variableType == aVariableTypeClass uniqueInstance
				and: [ each variableName asSymbol = aName ] ]
]
