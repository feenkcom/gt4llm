Class {
	#name : #GtLIceClassChangeHistoryBuilderExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Summarizers'
}

{ #category : #'private - assertions' }
GtLIceClassChangeHistoryBuilderExamples >> assertMixedHistory: aHistory [
	| classChange originalClass updatedClass instanceMethod classMethod addedMethod removedMethod |
	self assert: aHistory targetClassName asSymbol equals: self targetClassName.
	self assert: aHistory behaviourChanges size equals: 1.
	classChange := aHistory initialBehaviourChange changeResult.
	originalClass := classChange originalClass.
	updatedClass := classChange updatedClass.
	self
		assert: (originalClass instanceSlotNames collect: #asSymbol) asSet
		equals: #(stableSlot removedSlot movedSlot) asSet.
	self
		assert: (updatedClass instanceSlotNames collect: #asSymbol) asSet
		equals: #(stableSlot addedSlot) asSet.
	self
		assert: (originalClass classSlotNames collect: #asSymbol) asSet
		equals: #(removedClassSlot) asSet.
	self
		assert: (updatedClass classSlotNames collect: #asSymbol) asSet
		equals: #(movedSlot addedClassSlot) asSet.
	self
		assert: (originalClass classVariableNames collect: #asSymbol) asSet
		equals: #(OldShared) asSet.
	self
		assert: (updatedClass classVariableNames collect: #asSymbol) asSet
		equals: #(NewShared) asSet.
	self assert: aHistory variableChangeHistories size equals: 8.
	self assert: aHistory methodHistories size equals: 4.
	instanceMethod := self
			methodHistoryNamed: #sharedSelector
			classSide: false
			in: aHistory.
	classMethod := self
			methodHistoryNamed: #sharedSelector
			classSide: true
			in: aHistory.
	addedMethod := self
			methodHistoryNamed: #addedMethod
			classSide: false
			in: aHistory.
	removedMethod := self
			methodHistoryNamed: #removedMethod
			classSide: false
			in: aHistory.
	self
		assert: instanceMethod initialChange changeResult oldStateMethodSourceCode
		equals: 'sharedSelector self removedMethod. ^ removedSlot'.
	self
		assert: instanceMethod latestChange changeResult newStateMethodSourceCode
		equals: 'sharedSelector self addedMethod. ^ addedSlot'.
	self
		assert: classMethod initialChange changeResult oldStateMethodSourceCode
		equals: 'sharedSelector ^ removedClassSlot + OldShared'.
	self
		assert: classMethod latestChange changeResult newStateMethodSourceCode
		equals: 'sharedSelector ^ movedSlot + NewShared + addedClassSlot'.
	self assert: addedMethod isInitialChangeAddition.
	self
		assert: addedMethod latestChange changeResult newStateMethodSourceCode
		equals: 'addedMethod ^ addedSlot'.
	self assert: removedMethod isLatestChangeRemoval.
	self
		assert: removedMethod initialChange changeResult oldStateMethodSourceCode
		equals: 'removedMethod ^ removedSlot'
]

{ #category : #'private - fixtures' }
GtLIceClassChangeHistoryBuilderExamples >> classDefinitionWithInstanceSlots: instanceSlots classSlots: classSlots classVariables: classVariables [
	^ (MCClassDefinition named: self targetClassName)
		packageName: self packageName;
		instVarNames: instanceSlots;
		classInstVarNames: classSlots;
		classVarNames: classVariables;
		yourself
]

{ #category : #'private - fixtures' }
GtLIceClassChangeHistoryBuilderExamples >> classSideNodeIn: aPackageNode [
	^ aPackageNode / (self targetClassName , ' class')
]

{ #category : #examples }
GtLIceClassChangeHistoryBuilderExamples >> historyForMethodOnlyChange [
	<gtExample>
	<return: #GtLClassChangeHistory>
	| original updated diff classNode history |
	original := self originalDefinitions.
	updated := original copy.
	updated
		at: 2
		put: (self
				methodDefinitionNamed: #sharedSelector
				classSide: false
				source: 'sharedSelector ^ 42').
	diff := self iceDiffFrom: original to: updated.
	classNode := self instanceClassNodeIn: diff.
	self assert: classNode value isNoModification.
	history := GtLIceClassChangeHistoryBuilder historyFor: classNode.
	self assert: history hasOnlyMethodChanges.
	self assert: history methodHistories size equals: 1.
	self
		assert: history methodHistories first latestChange changeResult newStateMethodSourceCode
		equals: 'sharedSelector ^ 42'.
	^ history
]

{ #category : #examples }
GtLIceClassChangeHistoryBuilderExamples >> historyFromBothSides [
	<gtExample>
	<return: #GtLClassChangeHistory>
	| diff instanceHistory classHistory |
	diff := self iceClassDiff.
	instanceHistory := GtLIceClassChangeHistoryBuilder
			historyFor: (self instanceClassNodeIn: diff).
	classHistory := GtLIceClassChangeHistoryBuilder
			historyFor: (self classSideNodeIn: diff).
	self assertMixedHistory: instanceHistory.
	self assertMixedHistory: classHistory.
	^ instanceHistory
]

{ #category : #examples }
GtLIceClassChangeHistoryBuilderExamples >> iceBlueprintView [
	<gtExample>
	<return: #GtPhlowCanvassableView>
	| diff instanceNode methodNode emptyView view blueprint history changed added removed |
	diff := self iceClassDiff.
	instanceNode := self instanceClassNodeIn: diff.
	methodNode := instanceNode / #sharedSelector.
	emptyView := GtPhlowView empty.
	self assert: (GtLIceClassChangeHistoryBuilder historyFor: diff) isNil.
	self assert: (GtLIceClassChangeHistoryBuilder historyFor: methodNode) isNil.
	self
		assert: (diff gtViewClassBlueprintFor: emptyView) class
		equals: emptyView class.
	self
		assert: (methodNode gtViewClassBlueprintFor: emptyView) class
		equals: emptyView class.
	view := (self classSideNodeIn: diff) gtViewClassBlueprintFor: emptyView.
	self assert: (view isKindOf: GtPhlowCanvassableView).
	self assert: view title equals: 'Class Blueprint'.
	blueprint := view stencilBuilder build.
	self assert: (blueprint isKindOf: GtLClassChangeBlueprint).
	history := blueprint classHistory.
	self assertMixedHistory: history.
	changed := self
			methodHistoryNamed: #sharedSelector
			classSide: false
			in: history.
	added := self
			methodHistoryNamed: #addedMethod
			classSide: false
			in: history.
	removed := self
			methodHistoryNamed: #removedMethod
			classSide: false
			in: history.
	self
		assert: (blueprint relationshipStatuses
				at: {changed.
						added})
		equals: #added.
	self
		assert: (blueprint relationshipStatuses
				at: {changed.
						removed})
		equals: #removed.
	self assert: view stencilBuilder asElement children isNotEmpty.
	^ view
]

{ #category : #examples }
GtLIceClassChangeHistoryBuilderExamples >> iceClassDiff [
	<gtExample>
	<return: #IceNode>
	| diff instanceNode classNode |
	diff := self iceDiffFrom: self originalDefinitions to: self updatedDefinitions.
	instanceNode := self instanceClassNodeIn: diff.
	classNode := self classSideNodeIn: diff.
	self assert: (Smalltalk globals includesKey: self targetClassName) not.
	self assert: instanceNode value isModification.
	self assert: classNode value isModification.
	self assert: (instanceNode / #sharedSelector) value isModification.
	self assert: (classNode / #sharedSelector) value isModification.
	self assert: (instanceNode / #addedMethod) value isAddition.
	self assert: (instanceNode / #removedMethod) value isRemoval.
	self assert: (instanceNode / #unchangedMethod) value isNoModification.
	^ diff
]

{ #category : #'private - fixtures' }
GtLIceClassChangeHistoryBuilderExamples >> iceDiffFrom: originalDefinitions to: updatedDefinitions [
	^ IceDiff new
		mergedTreeOf: (self packageNodeWithDefinitions: updatedDefinitions)
		with: (self packageNodeWithDefinitions: originalDefinitions)
]

{ #category : #'private - fixtures' }
GtLIceClassChangeHistoryBuilderExamples >> instanceClassNodeIn: aPackageNode [
	^ aPackageNode / self targetClassName
]

{ #category : #'private - fixtures' }
GtLIceClassChangeHistoryBuilderExamples >> methodDefinitionNamed: aSelector classSide: isClassSide source: aSource [
	^ MCMethodDefinition
		className: self targetClassName
		classIsMeta: isClassSide
		selector: aSelector
		category: 'accessing'
		timeStamp: ''
		source: aSource
]

{ #category : #'private - assertions' }
GtLIceClassChangeHistoryBuilderExamples >> methodHistoryNamed: aSelector classSide: isClassSide in: aClassHistory [
	^ aClassHistory methodHistories
		detect: [ :each | 
			each methodReference methodName asSymbol = aSelector
				and: [ each methodReference isClassSide = isClassSide ] ]
]

{ #category : #'private - fixtures' }
GtLIceClassChangeHistoryBuilderExamples >> originalDefinitions [
	^ {self
			classDefinitionWithInstanceSlots: #(stableSlot '#removedSlot => InstanceVariableSlot' movedSlot)
			classSlots: #(removedClassSlot)
			classVariables: #(OldShared).
		self
			methodDefinitionNamed: #sharedSelector
			classSide: false
			source: 'sharedSelector self removedMethod. ^ removedSlot'.
		self
			methodDefinitionNamed: #sharedSelector
			classSide: true
			source: 'sharedSelector ^ removedClassSlot + OldShared'.
		self
			methodDefinitionNamed: #removedMethod
			classSide: false
			source: 'removedMethod ^ removedSlot'.
		self
			methodDefinitionNamed: #unchangedMethod
			classSide: false
			source: 'unchangedMethod ^ 42'}
]

{ #category : #'private - fixtures' }
GtLIceClassChangeHistoryBuilderExamples >> packageName [
	^ 'SomePackage-Examples'
]

{ #category : #'private - fixtures' }
GtLIceClassChangeHistoryBuilderExamples >> packageNodeWithDefinitions: someDefinitions [
	| node importer |
	node := IceNode
			value: ((IcePackageDefinition named: self packageName)
					packageName: self packageName;
					yourself).
	importer := IceMCDefinitionImporter new
			packageNode: node;
			snapshot: (MCSnapshot fromDefinitions: someDefinitions);
			yourself.
	someDefinitions do: [ :each | each accept: importer ].
	^ node
]

{ #category : #'private - fixtures' }
GtLIceClassChangeHistoryBuilderExamples >> targetClassName [
	^ #GtLIceBlueprintAbsentExampleTarget
]

{ #category : #'private - fixtures' }
GtLIceClassChangeHistoryBuilderExamples >> updatedDefinitions [
	^ {self
			classDefinitionWithInstanceSlots: #(stableSlot addedSlot)
			classSlots: #(movedSlot '#addedClassSlot => InstanceVariableSlot')
			classVariables: #(NewShared).
		self
			methodDefinitionNamed: #sharedSelector
			classSide: false
			source: 'sharedSelector self addedMethod. ^ addedSlot'.
		self
			methodDefinitionNamed: #sharedSelector
			classSide: true
			source: 'sharedSelector ^ movedSlot + NewShared + addedClassSlot'.
		self
			methodDefinitionNamed: #addedMethod
			classSide: false
			source: 'addedMethod ^ addedSlot'.
		self
			methodDefinitionNamed: #unchangedMethod
			classSide: false
			source: 'unchangedMethod ^ 42'}
]

{ #category : #examples }
GtLIceClassChangeHistoryBuilderExamples >> wholeClassHistories [
	<gtExample>
	<return: #Array>
	| addition removal addedHistory removedHistory |
	addition := self iceDiffFrom: #() to: self updatedDefinitions.
	removal := self iceDiffFrom: self originalDefinitions to: #().
	addedHistory := GtLIceClassChangeHistoryBuilder
			historyFor: (self classSideNodeIn: addition).
	removedHistory := GtLIceClassChangeHistoryBuilder
			historyFor: (self instanceClassNodeIn: removal).
	self assert: addedHistory isInitialDefinitionChangeAddition.
	self assert: removedHistory isLatestDefinitionChangeRemoval.
	self assert: addedHistory methodHistories size equals: 4.
	self assert: removedHistory methodHistories size equals: 4.
	self
		assert: (addedHistory methodHistories allSatisfy: #isInitialChangeAddition).
	self
		assert: (removedHistory methodHistories allSatisfy: #isLatestChangeRemoval).
	self
		assert: (addedHistory variableChangeHistories allSatisfy: #isInitialChangeAddition).
	self
		assert: (removedHistory variableChangeHistories allSatisfy: #isLatestChangeRemoval).
	^ {addedHistory.
		removedHistory}
]
