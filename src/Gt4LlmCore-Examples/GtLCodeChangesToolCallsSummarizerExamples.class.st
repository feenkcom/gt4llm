"
Examples for code changes tool call summarizer.
"
Class {
	#name : #GtLCodeChangesToolCallsSummarizerExamples,
	#superclass : #GtLToolCallsSummarizerExamplesBase,
	#instVars : [
		'createdClasses'
	],
	#category : #'Gt4LlmCore-Examples-Summarizers'
}

{ #category : #'utilities - refactorings' }
GtLCodeChangesToolCallsSummarizerExamples >> assertSummarizer: aSummarizer hasOnePackageHistoryFor: aClass withChangesCount: aNumber [
	| aPackageHistories |
	aPackageHistories := aSummarizer packageChangeHistories.
	self assert: aPackageHistories size equals: 1.
	self
		assert: aPackageHistories first targetPackageName asString
		equals: aClass package name asString.
	self assert: aPackageHistories first changes size equals: aNumber
]

{ #category : #'utilities - refactorings' }
GtLCodeChangesToolCallsSummarizerExamples >> classHistoryIn: aSummarizer named: aClassName [
	^ aSummarizer classChangeHistories
		detect: [ :each | each targetClassName asString = aClassName asString ]
]

{ #category : #examples }
GtLCodeChangesToolCallsSummarizerExamples >> classInPackageHistory [
	<gtExample>
	| packageHistory classHistory |
	
	packageHistory := self packageHistory.
	
	classHistory := packageHistory classHistories items first.
	
	self assert: classHistory class equals: GtLClassInPackageTagChangeHistory.
	self assert: classHistory targetClassName equals: 'GtLTemporarySummarizerExampleClass'.
	self assert: classHistory targetPackageName equals: 'Gt4LlmCore-Examples'.
	self assert: classHistory behaviourChanges size equals: 2.
	self assert: classHistory isInitialDefinitionChangeAddition.
	self assert: classHistory isLatestDefinitionChangeRemoval.
	self assert: classHistory hasNoEffect.
	
	^ classHistory
]

{ #category : #private }
GtLCodeChangesToolCallsSummarizerExamples >> cleanupCreatedClasses [
	createdClasses ifNil: [ ^ self ].
	createdClasses do: [ :eachClassName | self removeClassNamedIfPresent: eachClassName ].
	createdClasses removeAll
]

{ #category : #'examples - package histories' }
GtLCodeChangesToolCallsSummarizerExamples >> emptyPackageChangeHistory [
	<gtExample>
	| history |
	
	history := GtLPackageChangeHistory new.
	history targetPackageName: 'TestPackage'.
	
	self assert: history targetPackageName equals: 'TestPackage'.
	self assert: history classHistories isEmpty.
	self assert: history gtViewChangesCount equals: 0.
	self assert: history hasNoEffect.
	
	^ history
]

{ #category : #initialization }
GtLCodeChangesToolCallsSummarizerExamples >> initialize [
	super initialize.
	createdClasses := OrderedCollection new
]

{ #category : #'utilities - refactorings' }
GtLCodeChangesToolCallsSummarizerExamples >> labelsOf: aSummarizer [
	^ (aSummarizer codeChanges collect: [ :each | each label ]) asArray
]

{ #category : #examples }
GtLCodeChangesToolCallsSummarizerExamples >> messagesGroupWithExecutedClassCommentChange [
	<gtExample>
	<after: #cleanupCreatedClasses>
	| group createToolCall commentToolCall removeToolCall summarizer className |
	
	group := GtLMessagesGroup new.
	className := 'GtLTemporarySummarizerCommentChangeClass'.
	self removeClassNamedIfPresent: className.
	
	createToolCall := self performTrackedClassCreationNamed: className.
	group add: (self toolMessageFrom: createToolCall).
	
	commentToolCall := self performClassCommentChangeFor: (Smalltalk classNamed: className asSymbol) to: 'Temporary comment for summarizer example'.
	group add: (self toolMessageFrom: commentToolCall).
	
	removeToolCall := self performClassRemovalNamed: className.
	group add: (self toolMessageFrom: removeToolCall).
	
	summarizer := group toolCallsSummarizers 
		detect: [ :each | each class = GtLCodeChangesToolCallsSummarizer ].
	self assert: summarizer codeChanges size equals: 3.
	
	^ group
]

{ #category : #examples }
GtLCodeChangesToolCallsSummarizerExamples >> messagesGroupWithExecutedClassCreationAndRemoval [
	<gtExample>
	<after: #cleanupCreatedClasses>
	| group className createToolCall removeToolCall summarizer |
	
	group := GtLMessagesGroup new.
	className := 'GtLTemporarySummarizerExampleClass'.
	self removeClassNamedIfPresent: className.
	
	createToolCall := self performTrackedClassCreationNamed: className.
	group add: (self toolMessageFrom: createToolCall).
	
	removeToolCall := self performClassRemovalNamed: className.
	group add: (self toolMessageFrom: removeToolCall).
	
	summarizer := group toolCallsSummarizers 
		detect: [ :each | each class = GtLCodeChangesToolCallsSummarizer ].
	self assert: summarizer codeChanges size equals: 2.
	
	^ group
]

{ #category : #'examples - package move' }
GtLCodeChangesToolCallsSummarizerExamples >> messagesGroupWithExecutedClassPackageMove [
	<gtExample>
	<after: #cleanupCreatedClasses>
	| group className createToolCall moveToolCall summarizer |
	
	group := GtLMessagesGroup new.
	className := 'GtLTemporarySummarizerPackageMoveClass'.
	self removeClassNamedIfPresent: className.
	
	"Create class in package A"
	createToolCall := self performTrackedClassCreationNamed: className.
	group add: (self toolMessageFrom: createToolCall).
	
	"Move class to package B"
	moveToolCall := self performClassPackageChangeFor: className toPackage: 'Gt4LlmCore-Examples-Temp'.
	group add: (self toolMessageFrom: moveToolCall).
	
	summarizer := group toolCallsSummarizers 
		detect: [ :each | each class = GtLCodeChangesToolCallsSummarizer ].
	
	self assert: summarizer codeChanges size equals: 2.
	
	"Clean up"
	self removeClassNamedIfPresent: className.
	
	^ group
]

{ #category : #examples }
GtLCodeChangesToolCallsSummarizerExamples >> messagesGroupWithExecutedMethodCompilation [
	<gtExample>
	| group toolCall summarizer source selector |
	
	group := GtLMessagesGroup new.
	selector := #llmTemporaryCompiledMethodForSummarizer.
	source := 'llmTemporaryCompiledMethodForSummarizer ^ 42'.
	
	self removeSelector: selector fromClass: self class.
	toolCall := self performMethodCompilationFor: self class selector: selector source: source protocol: 'examples-temp'.
	group add: (self toolMessageFrom: toolCall).
	
	summarizer := group toolCallsSummarizers 
		detect: [ :each | each class = GtLCodeChangesToolCallsSummarizer ].
	self assert: summarizer codeChanges size equals: 1.
	self removeSelector: selector fromClass: self class.
	
	^ group
]

{ #category : #examples }
GtLCodeChangesToolCallsSummarizerExamples >> messagesGroupWithExecutedMethodCompilationAndRemoval [
	<gtExample>
	| group compileToolCall removeToolCall summarizer selector source |
	
	group := GtLMessagesGroup new.
	selector := #llmTemporaryMethodForRemovalSummarizer.
	source := 'llmTemporaryMethodForRemovalSummarizer ^ 7'.
	
	self removeSelector: selector fromClass: self class.
	compileToolCall := self performMethodCompilationFor: self class selector: selector source: source protocol: 'examples-temp'.
	group add: (self toolMessageFrom: compileToolCall).
	self assert: (self class includesSelector: selector).
	
	removeToolCall := self performMethodRemovalFor: self class selector: selector.
	group add: (self toolMessageFrom: removeToolCall).
	
	summarizer := group toolCallsSummarizers 
		detect: [ :each | each class = GtLCodeChangesToolCallsSummarizer ].
	self assert: summarizer codeChanges size equals: 2.
	
	^ group
]

{ #category : #'utilities - refactorings' }
GtLCodeChangesToolCallsSummarizerExamples >> methodHistoryIn: aSummarizer of: aClass selector: aSelector [
	^ aSummarizer methodChangeHistories
		detect: [ :each | 
			each methodReference methodClassName asString = aClass name asString
				and: [ each methodReference methodName asString = aSelector asString ] ]
]

{ #category : #'examples - builder' }
GtLCodeChangesToolCallsSummarizerExamples >> packageChangeHistoriesBuilder [
	<gtExample>
	| builder |
	
	builder := GtLPackageChangeHistoriesBuilder forCodeChanges: GtLSummarizerCodeChangesGroup new.
	
	self assert: builder codeChanges isEmpty.
	
	^ builder
]

{ #category : #'examples - builder' }
GtLCodeChangesToolCallsSummarizerExamples >> packageChangeHistoriesBuilderWithChanges [
	<gtExample>
	<after: #cleanupCreatedClasses>
	| group summarizer builder packageHistories |
	
	group := self messagesGroupWithExecutedClassCreationAndRemoval.
	summarizer := group toolCallsSummarizers 
		detect: [ :each | each class = GtLCodeChangesToolCallsSummarizer ].
	
	builder := GtLPackageChangeHistoriesBuilder forCodeChanges: summarizer codeChanges.
	
	self assert: builder codeChanges isNotEmpty.
	
	packageHistories := builder buildHistory.
	
	self assert: packageHistories isNotEmpty.
	self assert: packageHistories size equals: 1.
	
	^ builder
]

{ #category : #'examples - package histories' }
GtLCodeChangesToolCallsSummarizerExamples >> packageChangeHistoriesForClassCreationAndRemoval [
	<gtExample>
	<after: #cleanupCreatedClasses>
	| group summarizer packageHistories classHistory |
	
	group := self messagesGroupWithExecutedClassCreationAndRemoval.
	summarizer := group toolCallsSummarizers 
		detect: [ :each | each class = GtLCodeChangesToolCallsSummarizer ].
	
	packageHistories := summarizer packageChangeHistories.
	
	self assert: packageHistories isNotEmpty.
	
	"Find the package containing the temporary class"
	classHistory := packageHistories classHistories items 
		detect: [ :ch | ch targetClassName = 'GtLTemporarySummarizerExampleClass' ] 
		ifNone: [ nil ].
	self assert: classHistory isNotNil.
	self assert: classHistory hasNoEffect description: 'Class was created and then removed, so it should have no effect'.
	
	^ packageHistories
]

{ #category : #'examples - package move' }
GtLCodeChangesToolCallsSummarizerExamples >> packageChangeHistoriesForClassPackageMove [
	<gtExample>
	<after: #cleanupCreatedClasses>
	| group summarizer packageHistories sourcePackageHistory destPackageHistory sourceClassHistory destClassHistory |
	
	group := self messagesGroupWithExecutedClassPackageMove.
	summarizer := group toolCallsSummarizers 
		detect: [ :each | each class = GtLCodeChangesToolCallsSummarizer ].
	
	packageHistories := summarizer packageChangeHistories.
	
	"Should have 2 packages: source and destination"
	self assert: packageHistories size equals: 2.
	
	"Find source package (Gt4LlmCore-Examples)"
	sourcePackageHistory := packageHistories items 
		detect: [ :ph | ph targetPackageName = 'Gt4LlmCore-Examples' ]
		ifNone: [ nil ].
	self assert: sourcePackageHistory notNil.
	
	"Find destination package (Gt4LlmCore-Examples-Temp)"
	destPackageHistory := packageHistories items 
		detect: [ :ph | ph targetPackageName = 'Gt4LlmCore-Examples-Temp' ]
		ifNone: [ nil ].
	self assert: destPackageHistory notNil.
	
	"Source package should have the class with hasNoEffect (created then moved out)"
	sourceClassHistory := sourcePackageHistory classHistories items first.
	self assert: sourceClassHistory isInitialDefinitionChangeAddition description: 'Class was initially added to source package'.
	self assert: sourceClassHistory isLatestDefinitionChangeRemoval description: 'Class was moved out of source package'.
	self assert: sourceClassHistory hasNoEffect description: 'Net effect on source package is zero (added then moved out)'.
	
	"Destination package should have the class that was moved in"
	destClassHistory := destPackageHistory classHistories items first.
	self assert: destClassHistory isInitialDefinitionChangeAddition description: 'Class was moved into destination package'.
	self assert: destClassHistory isLatestDefinitionChangeRemoval not description: 'Class is still in destination package'.
	
	^ packageHistories
]

{ #category : #'examples - package histories' }
GtLCodeChangesToolCallsSummarizerExamples >> packageChangeHistoriesForMethodCompilation [
	<gtExample>
	| group summarizer packageHistories |
	
	group := self messagesGroupWithExecutedMethodCompilation.
	summarizer := group toolCallsSummarizers 
		detect: [ :each | each class = GtLCodeChangesToolCallsSummarizer ].
	
	packageHistories := summarizer packageChangeHistories.
	
	self assert: packageHistories isNotEmpty.
	"Note: the method might be removed already so the package may be 'Unknown'"
	self assert: packageHistories size equals: 1.
	
	^ packageHistories
]

{ #category : #'examples - package histories' }
GtLCodeChangesToolCallsSummarizerExamples >> packageChangeHistoriesGroup [
	<gtExample>
	| group |
	
	group := GtLPackageChangeHistoriesGroup new.
	
	self assert: group isEmpty.
	self assert: group items isEmpty.
	
	^ group
]

{ #category : #'examples - package histories' }
GtLCodeChangesToolCallsSummarizerExamples >> packageHistory [
	<gtExample>
	| packageHistories packageHistory |
	
	packageHistories := self packageChangeHistoriesForClassCreationAndRemoval.
	
	packageHistory := packageHistories items first.
	
	self assert: packageHistory targetPackageName equals: 'Gt4LlmCore-Examples'.
	self assert: packageHistory classHistories items size equals: 1.
	self assert: packageHistory gtViewChangesCount equals: 2.
	self assert: packageHistory hasNoEffect.
	
	^ packageHistory
]

{ #category : #utilities }
GtLCodeChangesToolCallsSummarizerExamples >> performTrackedClassCreationNamed: aClassName [
	| toolCall |
	toolCall := self performClassCreationNamed: aClassName.
	self trackCreatedClassNamed: aClassName.
	^ toolCall
]

{ #category : #private }
GtLCodeChangesToolCallsSummarizerExamples >> removeClassNamedIfPresent: aClassName [
	(Smalltalk hasClassNamed: aClassName asSymbol) ifTrue: [ 
		(Smalltalk classNamed: aClassName asSymbol) removeFromSystem ]
]

{ #category : #'examples - refactorings' }
GtLCodeChangesToolCallsSummarizerExamples >> summarizerIgnoresPreviewsAndFailedApplies [
	"Previews, and applies that fail before changing anything (an already applied preview, an unknown object id), add no code changes"

	<gtExample>
	^ self
		withRefactoringContextDo: [ :aRootClass :aLeafClass :aContext | 
			| anAppliedPreviewCall toolCalls summarizer previewToolNames |
			"Applied outside of the summarized tool calls, so that it can be applied a second time below"
			anAppliedPreviewCall := self
					performPreviewRefactoring: {self addMethodTransformationIn: aLeafClass source: 'summarizedMethod ^ 42'}
					inContext: aContext.
			self performApplyRefactoringOf: anAppliedPreviewCall inContext: aContext.

			toolCalls := OrderedCollection new.
			toolCalls
				add: (self
						performPreviewRefactoring: {self addMethodTransformationIn: aLeafClass source: 'neverApplied ^ 1'}
						inContext: aContext).
			toolCalls
				add: (self
						performPreviewRewriteFrom: '`@receiver summarizedMethod'
						to: '`@receiver method1'
						inClass: aLeafClass
						inContext: aContext).
			toolCalls
				add: (self performApplyRefactoringOf: anAppliedPreviewCall inContext: aContext).
			self assert: toolCalls last result model class equals: GtLProblemDomainObject.
			toolCalls
				add: (self
						performApplyRefactoringWithObjectId: 'unknown-object-id'
						inContext: aContext).
			self assert: toolCalls last result model class equals: GtLMissingDomainObject.
			self assert: (aLeafClass includesSelector: #neverApplied) not.

			summarizer := self codeChangesSummarizerForToolCalls: toolCalls.
			previewToolNames := {GtLToolForPreviewRefactoring new name.
					GtLToolForPreviewRewrite new name}.
			self
				assert: (summarizer relevantToolCalls
						anySatisfy: [ :each | previewToolNames includes: each name ]) not.
			self assert: summarizer codeChanges isEmpty.
			self assert: summarizer hasSummaryData not.
			self assert: summarizer methodChangeHistories isEmpty.
			self assert: summarizer classChangeHistories isEmpty.
			self assert: summarizer packageChangeHistories isEmpty.
			self assert: summarizer summaryText equals: 'No code changes'.
			summarizer ]
]

{ #category : #'examples - refactorings' }
GtLCodeChangesToolCallsSummarizerExamples >> summarizerWithAppliedAddClassRefactoring [
	"An applied AddClass refactoring is summarized as a class addition"

	<gtExample>
	^ self
		withRefactoringContextDo: [ :aRootClass :aLeafClass :aContext | 
			| aClassName toolCalls aPreview summarizer aResult aClassHistory |
			aClassName := aRootClass name , 'Added'.
			[ toolCalls := OrderedCollection new.
			toolCalls
				add: (self
						performPreviewRefactoring: {self
									addClassTransformationNamed: aClassName
									superclass: aRootClass
									slotNames: 'first'}
						inContext: aContext).
			aPreview := toolCalls last result model.
			self assert: aPreview refactoringName equals: 'Add class'.
			self
				assert: aPreview refactoringDescription
				equals: 'Add class ' , aClassName , ' as subclass of ' , aRootClass name
						, ' with slots first'.
			toolCalls
				add: (self performApplyRefactoringOf: toolCalls last inContext: aContext).
			self assert: (Smalltalk globals includesKey: aClassName asSymbol).

			summarizer := self codeChangesSummarizerForToolCalls: toolCalls.
			self assert: summarizer relevantToolCalls size equals: 1.
			self
				assert: (self labelsOf: summarizer)
				equals: #('Refactoring (Add class): added class').
			aResult := summarizer codeChanges first changeResult.
			self assert: aResult class equals: GtLClassModificationResult.
			self assert: aResult isClassAdditionResult.
			self assert: aResult targetClassName asString equals: aClassName.
			self assert: aResult superclassName asString equals: aRootClass name asString.

			self assert: summarizer methodChangeHistories isEmpty.
			self assert: summarizer classChangeHistories size equals: 1.
			aClassHistory := self classHistoryIn: summarizer named: aClassName.
			self assert: aClassHistory behaviourChanges size equals: 1.
			self assert: aClassHistory isInitialDefinitionChangeAddition.
			self
				assertSummarizer: summarizer
				hasOnePackageHistoryFor: aRootClass
				withChangesCount: 1.
			self
				assert: summarizer summaryText
				equals: '1 code changes from 1 tool calls'.
			summarizer ]
				ensure: [ (Smalltalk globals classNamed: aClassName)
						ifNotNil: [ :anAddedClass | anAddedClass removeFromSystem ] ] ]
]

{ #category : #'examples - refactorings' }
GtLCodeChangesToolCallsSummarizerExamples >> summarizerWithAppliedAddMethodRefactoring [
	"An applied AddMethod refactoring is summarized as a method addition, labelled with the name of the refactoring"

	<gtExample>
	^ self
		withRefactoringContextDo: [ :aRootClass :aLeafClass :aContext | 
			| toolCalls aPreview summarizer aResult aMethodHistory |
			toolCalls := OrderedCollection new.
			toolCalls
				add: (self
						performPreviewRefactoring: {self addMethodTransformationIn: aLeafClass source: 'summarizedMethod ^ 42'}
						inContext: aContext).
			aPreview := toolCalls last result model.
			self assert: aPreview refactoringName equals: 'Add method'.
			self
				assert: (aPreview refactoringDescription
						beginsWith: 'Add method summarizedMethod ^ 42 in class ' , aLeafClass name).
			toolCalls
				add: (self performApplyRefactoringOf: toolCalls last inContext: aContext).
			self assert: (aLeafClass includesSelector: #summarizedMethod).
			self assert: toolCalls last result model refactoringName equals: 'Add method'.

			summarizer := self codeChangesSummarizerForToolCalls: toolCalls.
			self assert: summarizer relevantToolCalls size equals: 1.
			self
				assert: (self labelsOf: summarizer)
				equals: #('Refactoring (Add method): added method').
			aResult := summarizer codeChanges first changeResult.
			self assert: aResult class equals: GtLMethodCompilationResult.
			self assert: aResult isMethodAdditionResult.
			self assert: aResult newMethod sourceCode equals: 'summarizedMethod ^ 42'.

			self assert: summarizer methodChangeHistories size equals: 1.
			aMethodHistory := self
					methodHistoryIn: summarizer
					of: aLeafClass
					selector: #summarizedMethod.
			self assert: aMethodHistory changes size equals: 1.
			self assert: aMethodHistory isInitialChangeAddition.
			self assert: summarizer classChangeHistories size equals: 1.
			self
				assertSummarizer: summarizer
				hasOnePackageHistoryFor: aLeafClass
				withChangesCount: 1.
			self
				assert: summarizer summaryText
				equals: '1 code changes from 1 tool calls'.
			summarizer ]
]

{ #category : #'examples - refactorings' }
GtLCodeChangesToolCallsSummarizerExamples >> summarizerWithAppliedPushUpInstanceVariableRefactoring [
	"An applied PushUpInstanceVariable refactoring is summarized as a change of the definitions of both classes"

	<gtExample>
	^ self
		withRefactoringContextDo: [ :aRootClass :aLeafClass :aContext | 
			| toolCalls aPreview summarizer aRootResult aLeafResult |
			toolCalls := OrderedCollection new.
			toolCalls
				add: (self
						performPreviewRefactoring: {self pushUpInstanceVariableTransformationOf: #instVar3 to: aRootClass}
						inContext: aContext).
			aPreview := toolCalls last result model.
			self assert: aPreview refactoringName equals: 'Push up instance variable'.
			self
				assert: aPreview refactoringDescription
				equals: 'Push up slot instVar3 to ' , aRootClass name.
			toolCalls
				add: (self performApplyRefactoringOf: toolCalls last inContext: aContext).
			self assert: (aRootClass instVarNames includes: #instVar3).
			self assert: (aLeafClass instVarNames includes: #instVar3) not.

			summarizer := self codeChangesSummarizerForToolCalls: toolCalls.
			self assert: summarizer relevantToolCalls size equals: 1.
			self
				assert: (self labelsOf: summarizer)
				equals: #('Refactoring (Push up instance variable): changed class' 'Refactoring (Push up instance variable): changed class').
			self
				assert: (summarizer codeChanges
						allSatisfy: [ :each | 
							each changeResult class = GtLClassModificationResult
								and: [ each changeResult isClassModificationResult ] ]).
			aRootResult := (summarizer codeChanges
					detect: [ :each | each changeResult targetClassName asString = aRootClass name asString ])
					changeResult.
			self
				assert: (aRootResult originalClass instanceSlotNames includes: #instVar3) not.
			self assert: (aRootResult updatedClass instanceSlotNames includes: #instVar3).
			aLeafResult := (summarizer codeChanges
					detect: [ :each | each changeResult targetClassName asString = aLeafClass name asString ])
					changeResult.
			self
				assert: (aLeafResult originalClass instanceSlotNames includes: #instVar3).
			self
				assert: (aLeafResult updatedClass instanceSlotNames includes: #instVar3) not.

			self assert: summarizer methodChangeHistories isEmpty.
			self assert: summarizer classChangeHistories size equals: 2.
			self
				assert: (self classHistoryIn: summarizer named: aRootClass name) behaviourChanges size
				equals: 1.
			self
				assert: (self classHistoryIn: summarizer named: aLeafClass name) behaviourChanges size
				equals: 1.
			self
				assertSummarizer: summarizer
				hasOnePackageHistoryFor: aRootClass
				withChangesCount: 2.
			self
				assert: summarizer summaryText
				equals: '2 code changes from 1 tool calls'.
			summarizer ]
]

{ #category : #'examples - refactorings' }
GtLCodeChangesToolCallsSummarizerExamples >> summarizerWithAppliedPushUpMethodRefactoring [
	"An applied PushUpMethod refactoring is summarized as an addition in the superclass and a removal in the subclass"

	<gtExample>
	^ self
		withRefactoringContextDo: [ :aRootClass :aLeafClass :aContext | 
			| toolCalls aPreview summarizer |
			aLeafClass compile: 'summarizedMethod ^ 42' classified: #examples.
			toolCalls := OrderedCollection new.
			toolCalls
				add: (self
						performPreviewRefactoring: {self
									pushUpMethodTransformationOf: #summarizedMethod
									from: aLeafClass
									to: aRootClass}
						inContext: aContext).
			aPreview := toolCalls last result model.
			self assert: aPreview refactoringName equals: 'Push up method'.
			self
				assert: aPreview refactoringDescription
				equals: 'Push up method summarizedMethod from ' , aLeafClass name , ' to '
						, aRootClass name.
			toolCalls
				add: (self performApplyRefactoringOf: toolCalls last inContext: aContext).
			self assert: (aRootClass includesSelector: #summarizedMethod).
			self assert: (aLeafClass includesSelector: #summarizedMethod) not.

			summarizer := self codeChangesSummarizerForToolCalls: toolCalls.
			self assert: summarizer relevantToolCalls size equals: 1.
			self
				assert: (self labelsOf: summarizer)
				equals: #('Refactoring (Push up method): added method' 'Refactoring (Push up method): removed method').
			self
				assert: (summarizer codeChanges collect: [ :each | each changeResult class ]) asArray
				equals: {GtLMethodCompilationResult.
						GtLMethodRemovalResult}.

			self assert: summarizer methodChangeHistories size equals: 2.
			self
				assert: (self
						methodHistoryIn: summarizer
						of: aRootClass
						selector: #summarizedMethod) isInitialChangeAddition.
			self
				assert: (self
						methodHistoryIn: summarizer
						of: aLeafClass
						selector: #summarizedMethod) isLatestChangeRemoval.
			self assert: summarizer classChangeHistories size equals: 2.
			self
				assertSummarizer: summarizer
				hasOnePackageHistoryFor: aRootClass
				withChangesCount: 2.
			self
				assert: summarizer summaryText
				equals: '2 code changes from 1 tool calls'.
			summarizer ]
]

{ #category : #'examples - refactorings' }
GtLCodeChangesToolCallsSummarizerExamples >> summarizerWithAppliedRemoveMethodRefactoring [
	"An applied RemoveMethod refactoring is summarized as a method removal that keeps the removed source"

	<gtExample>
	^ self
		withRefactoringContextDo: [ :aRootClass :aLeafClass :aContext | 
			| toolCalls aPreview summarizer aResult aMethodHistory |
			aLeafClass compile: 'summarizedMethod ^ 42' classified: #examples.
			toolCalls := OrderedCollection new.
			toolCalls
				add: (self
						performPreviewRefactoring: {self removeMethodTransformationOf: #summarizedMethod in: aLeafClass}
						inContext: aContext).
			aPreview := toolCalls last result model.
			self assert: aPreview refactoringName equals: 'Remove method'.
			self
				assert: aPreview refactoringDescription
				equals: 'Remove method summarizedMethod from class ' , aLeafClass name.
			toolCalls
				add: (self performApplyRefactoringOf: toolCalls last inContext: aContext).
			self assert: (aLeafClass includesSelector: #summarizedMethod) not.

			summarizer := self codeChangesSummarizerForToolCalls: toolCalls.
			self assert: summarizer relevantToolCalls size equals: 1.
			self
				assert: (self labelsOf: summarizer)
				equals: #('Refactoring (Remove method): removed method').
			aResult := summarizer codeChanges first changeResult.
			self assert: aResult class equals: GtLMethodRemovalResult.
			self assert: aResult removedMethod sourceCode equals: 'summarizedMethod ^ 42'.

			self assert: summarizer methodChangeHistories size equals: 1.
			aMethodHistory := self
					methodHistoryIn: summarizer
					of: aLeafClass
					selector: #summarizedMethod.
			self assert: aMethodHistory isLatestChangeRemoval.
			self assert: summarizer classChangeHistories size equals: 1.
			self
				assertSummarizer: summarizer
				hasOnePackageHistoryFor: aLeafClass
				withChangesCount: 1.
			self
				assert: summarizer summaryText
				equals: '1 code changes from 1 tool calls'.
			summarizer ]
]

{ #category : #'examples - refactorings' }
GtLCodeChangesToolCallsSummarizerExamples >> summarizerWithAppliedRewrite [
	"An applied rewrite is summarized as a modification of each rewritten method"

	<gtExample>
	^ self
		withRefactoringContextDo: [ :aRootClass :aLeafClass :aContext | 
			| toolCalls aPreview summarizer aResult aMethodHistory |
			aRootClass compile: 'summarizedRewrite ^ self method1' classified: #examples.
			toolCalls := OrderedCollection new.
			toolCalls
				add: (self
						performPreviewRewriteFrom: '`@receiver method1'
						to: '`@receiver method2'
						inClass: aRootClass
						inContext: aContext).
			aPreview := toolCalls last result model.
			self assert: aPreview refactoringName equals: 'Rewrite'.
			self
				assert: aPreview refactoringDescription
				equals: 'Rewrite `@receiver method1 → `@receiver method2 in class ' , aRootClass name.
			toolCalls
				add: (self performApplyRefactoringOf: toolCalls last inContext: aContext).
			self
				assert: ((aRootClass >> #summarizedRewrite) sourceCode includesSubstring: 'method2').

			summarizer := self codeChangesSummarizerForToolCalls: toolCalls.
			self assert: summarizer relevantToolCalls size equals: 1.
			self
				assert: (self labelsOf: summarizer)
				equals: #('Refactoring (Rewrite): modified method').
			aResult := summarizer codeChanges first changeResult.
			self assert: aResult class equals: GtLMethodCompilationResult.
			self assert: aResult isMethodModificationResult.
			self assert: (aResult oldMethod sourceCode includesSubstring: 'method1').
			self assert: (aResult newMethod sourceCode includesSubstring: 'method2').

			self assert: summarizer methodChangeHistories size equals: 1.
			aMethodHistory := self
					methodHistoryIn: summarizer
					of: aRootClass
					selector: #summarizedRewrite.
			self assert: aMethodHistory changes size equals: 1.
			self assert: aMethodHistory isInitialChangeAddition not.
			self assert: summarizer classChangeHistories size equals: 1.
			self
				assertSummarizer: summarizer
				hasOnePackageHistoryFor: aRootClass
				withChangesCount: 1.
			self
				assert: summarizer summaryText
				equals: '1 code changes from 1 tool calls'.
			summarizer ]
]

{ #category : #'examples - refactorings' }
GtLCodeChangesToolCallsSummarizerExamples >> summarizerWithMethodChangesAndAppliedRefactorings [
	"Changes done by the method tools and by an applied refactoring are summarized together.
	The history of a method merges both kinds of changes, in order, with their own labels"

	<gtExample>
	^ self
		withRefactoringContextDo: [ :aRootClass :aLeafClass :aContext | 
			| toolCalls summarizer changesByTool aRootHistory aLeafHistory |
			toolCalls := OrderedCollection new.	"1. Compile a method in the leaf class"
			toolCalls
				add: (self
						performMethodCompilationFor: aLeafClass
						selector: #summarizedMethod
						source: 'summarizedMethod ^ 1'
						protocol: 'examples').	"2. Push it up with a refactoring"
			toolCalls
				add: (self
						performPreviewRefactoring: {self
									pushUpMethodTransformationOf: #summarizedMethod
									from: aLeafClass
									to: aRootClass}
						inContext: aContext).
			toolCalls
				add: (self performApplyRefactoringOf: toolCalls last inContext: aContext).	"3. Modify the pushed up method and then remove it"
			toolCalls
				add: (self
						performMethodCompilationFor: aRootClass
						selector: #summarizedMethod
						source: 'summarizedMethod ^ 2'
						protocol: 'examples').
			toolCalls
				add: (self performMethodRemovalFor: aRootClass selector: #summarizedMethod).
			self assert: (aRootClass includesSelector: #summarizedMethod) not.
			self assert: (aLeafClass includesSelector: #summarizedMethod) not.

			summarizer := self codeChangesSummarizerForToolCalls: toolCalls.
			self
				assert: (summarizer relevantToolCalls collect: [ :each | each name ]) asArray
				equals: {GtLMagritteToolForMethodCompilation new name.
						GtLToolForApplyRefactoring new name.
						GtLMagritteToolForMethodCompilation new name.
						GtLMagritteToolForMethodRemoval new name}.
			self
				assert: (self labelsOf: summarizer)
				equals: #('Compiled method' 'Refactoring (Push up method): added method' 'Refactoring (Push up method): removed method' 'Compiled method' 'Removed method').
			self
				assert: (summarizer codeChanges collect: [ :each | each changeResult class ]) asArray
				equals: {GtLMethodCompilationResult.
						GtLMethodCompilationResult.
						GtLMethodRemovalResult.
						GtLMethodCompilationResult.
						GtLMethodRemovalResult}.	"The data of the 'By tool' view"
			changesByTool := summarizer codeChanges
					groupedBy: [ :each | each toolCall name ].
			self assert: changesByTool size equals: 3.
			self
				assert: (changesByTool at: GtLMagritteToolForMethodCompilation new name) size
				equals: 2.
			self
				assert: (changesByTool at: GtLToolForApplyRefactoring new name) size
				equals: 2.
			self
				assert: (changesByTool at: GtLMagritteToolForMethodRemoval new name) size
				equals: 1.

			self assert: summarizer methodChangeHistories size equals: 2.
			aRootHistory := self
					methodHistoryIn: summarizer
					of: aRootClass
					selector: #summarizedMethod.
			self
				assert: (aRootHistory changes collect: [ :each | each label ]) asArray
				equals: #('Refactoring (Push up method): added method' 'Compiled method' 'Removed method').
			self
				assert: (aRootHistory changes at: 2) changeResult isMethodModificationResult.
			self assert: aRootHistory hasNoEffect.
			aLeafHistory := self
					methodHistoryIn: summarizer
					of: aLeafClass
					selector: #summarizedMethod.
			self
				assert: (aLeafHistory changes collect: [ :each | each label ]) asArray
				equals: #('Compiled method' 'Refactoring (Push up method): removed method').
			self assert: aLeafHistory hasNoEffect.

			self assert: summarizer classChangeHistories size equals: 2.
			self
				assertSummarizer: summarizer
				hasOnePackageHistoryFor: aRootClass
				withChangesCount: 5.
			self
				assert: summarizer summaryText
				equals: '5 code changes from 4 tool calls'.
			summarizer ]
]

{ #category : #'examples - refactorings' }
GtLCodeChangesToolCallsSummarizerExamples >> summarizerWithPartiallyAppliedRefactoring [
	"When applying a refactoring fails partway, only the changes applied before the error are summarized"

	<gtExample>
	^ self
		withRefactoringContextDo: [ :aRootClass :aLeafClass :aContext | 
			| aTemporaryClass toolCalls anAppliedRefactoring summarizer aResult |
			aTemporaryClass := aRootClass
					subclass: (aRootClass name , 'Temporary') asSymbol
					instanceVariableNames: ''
					classVariableNames: ''
					package: aRootClass package name.
			[ toolCalls := OrderedCollection new.
			toolCalls
				add: (self
						performPreviewRefactoring: {self addMethodTransformationIn: aLeafClass source: 'appliedBeforeFailure ^ 1'.
								self
									addMethodTransformationIn: aTemporaryClass
									source: 'neverApplied ^ 2'}
						inContext: aContext).	"Remove the class of the second change, so that applying fails after the first change"
			aTemporaryClass removeFromSystem.
			toolCalls
				add: (self performApplyRefactoringOf: toolCalls last inContext: aContext).
			anAppliedRefactoring := toolCalls last result model.
			self assert: anAppliedRefactoring status equals: 'failed'.
			self assert: anAppliedRefactoring hasFailed.
			self assert: (aLeafClass includesSelector: #appliedBeforeFailure).

			summarizer := self codeChangesSummarizerForToolCalls: toolCalls.
			self assert: summarizer relevantToolCalls size equals: 1.
			self
				assert: (self labelsOf: summarizer)
				equals: #('Refactoring (Add method): added method').
			aResult := summarizer codeChanges first changeResult.
			self assert: aResult class equals: GtLMethodCompilationResult.
			self
				assert: aResult targetMethodReference methodClassName asString
				equals: aLeafClass name asString.
			self
				assert: aResult targetMethodReference methodName
				equals: 'appliedBeforeFailure'.
			self assert: summarizer methodChangeHistories size equals: 1.
			self assert: summarizer classChangeHistories size equals: 1.
			self
				assertSummarizer: summarizer
				hasOnePackageHistoryFor: aLeafClass
				withChangesCount: 1.
			self
				assert: summarizer summaryText
				equals: '1 code changes from 1 tool calls'.
			summarizer ]
				ensure: [ aTemporaryClass isObsolete ifFalse: [ aTemporaryClass removeFromSystem ] ] ]
]

{ #category : #'examples - refactorings' }
GtLCodeChangesToolCallsSummarizerExamples >> summarizerWithSeveralAppliedRefactorings [
	"Several applied refactorings, one of them with several transformations, are summarized together.
	Each code change is labelled with the name of the refactoring that did it.
	The histories of a method merge the changes done by different refactorings, in order"

	<gtExample>
	^ self
		withRefactoringContextDo: [ :aRootClass :aLeafClass :aContext | 
			| toolCalls pushUpApplyCall summarizer aRootHistory aLeafHistory pushUpName |
			pushUpName := 'Push up instance variable, Push up method'.
			toolCalls := OrderedCollection new.	"1. Add a method that uses a slot of the leaf class"
			toolCalls
				add: (self
						performPreviewRefactoring: {self
									addMethodTransformationIn: aLeafClass
									source: 'summarizedMethod ^ instVar3 ifNil: [ self method1 ]'}
						inContext: aContext).
			toolCalls
				add: (self performApplyRefactoringOf: toolCalls last inContext: aContext).	"2. Push up the slot and the method with one preview of two transformations"
			toolCalls
				add: (self
						performPreviewRefactoring: {self pushUpInstanceVariableTransformationOf: #instVar3 to: aRootClass.
								self
									pushUpMethodTransformationOf: #summarizedMethod
									from: aLeafClass
									to: aRootClass}
						inContext: aContext).
			self assert: toolCalls last result model refactoringName equals: pushUpName.
			self
				assert: toolCalls last result model refactoringDescription
				equals: 'Push up slot instVar3 to ' , aRootClass name
						, '; Push up method summarizedMethod from ' , aLeafClass name , ' to '
						, aRootClass name.
			pushUpApplyCall := self
					performApplyRefactoringOf: toolCalls last
					inContext: aContext.
			toolCalls add: pushUpApplyCall.
			self assert: pushUpApplyCall result model codeChangeResults size equals: 4.	"3. Rewrite the pushed up method"
			toolCalls
				add: (self
						performPreviewRewriteFrom: '`@receiver method1'
						to: '`@receiver method2'
						inClass: aRootClass
						inContext: aContext).
			toolCalls
				add: (self performApplyRefactoringOf: toolCalls last inContext: aContext).
			self
				assert: ((aRootClass >> #summarizedMethod) sourceCode includesSubstring: 'method2').

			summarizer := self codeChangesSummarizerForToolCalls: toolCalls.
			self assert: toolCalls size equals: 6.
			self assert: summarizer relevantToolCalls size equals: 3.
			self
				assert: (summarizer relevantToolCalls
						allSatisfy: [ :each | each name = GtLToolForApplyRefactoring new name ]).
			self
				assert: (self labelsOf: summarizer)
				equals: {'Refactoring (Add method): added method'.
						'Refactoring (' , pushUpName , '): changed class'.
						'Refactoring (' , pushUpName , '): changed class'.
						'Refactoring (' , pushUpName , '): added method'.
						'Refactoring (' , pushUpName , '): removed method'.
						'Refactoring (Rewrite): modified method'}.

			self assert: summarizer methodChangeHistories size equals: 2.
			aRootHistory := self
					methodHistoryIn: summarizer
					of: aRootClass
					selector: #summarizedMethod.
			self
				assert: (aRootHistory changes collect: [ :each | each label ]) asArray
				equals: {'Refactoring (' , pushUpName , '): added method'.
						'Refactoring (Rewrite): modified method'}.
			self assert: aRootHistory isInitialChangeAddition.
			self assert: aRootHistory isLatestChangeRemoval not.
			aLeafHistory := self
					methodHistoryIn: summarizer
					of: aLeafClass
					selector: #summarizedMethod.
			self
				assert: (aLeafHistory changes collect: [ :each | each label ]) asArray
				equals: {'Refactoring (Add method): added method'.
						'Refactoring (' , pushUpName , '): removed method'}.
			self assert: aLeafHistory hasNoEffect.

			self assert: summarizer classChangeHistories size equals: 2.
			{aRootClass.
				aLeafClass}
				do: [ :eachClass | 
					| aClassHistory |
					aClassHistory := self classHistoryIn: summarizer named: eachClass name.
					self assert: aClassHistory methodHistories size equals: 1.
					self assert: aClassHistory behaviourChanges size equals: 1 ].
			self
				assertSummarizer: summarizer
				hasOnePackageHistoryFor: aRootClass
				withChangesCount: 6.
			self
				assert: summarizer summaryText
				equals: '6 code changes from 3 tool calls'.
			summarizer ]
]

{ #category : #private }
GtLCodeChangesToolCallsSummarizerExamples >> trackCreatedClassNamed: aClassName [
	createdClasses add: aClassName
]
