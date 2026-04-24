"
Examples for code changes tool call summarizer.
"
Class {
	#name : #GtLCodeChangesToolCallsSummarizerExamples,
	#superclass : #GtLToolCallsSummarizerExamplesBase,
	#instVars : [
		'createdClasses'
	],
	#category : 'Gt4LlmCore-Examples-Summarizers'
}

{ #category : #'examples - package histories' }
GtLCodeChangesToolCallsSummarizerExamples >> classInPackageHistory [
	<gtExample>
	| packageHistory classHistory |
	
	packageHistory := self packageHistory.
	
	classHistory := packageHistory classHistories items first.
	
	self assert: classHistory class equals: GtLClassInPackageChangeHistory.
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
	
	summarizer := group messageSummarizers 
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
	
	summarizer := group messageSummarizers 
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
	
	summarizer := group messageSummarizers 
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
	
	summarizer := group messageSummarizers 
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
	
	summarizer := group messageSummarizers 
		detect: [ :each | each class = GtLCodeChangesToolCallsSummarizer ].
	self assert: summarizer codeChanges size equals: 2.
	
	^ group
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
	summarizer := group messageSummarizers 
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
	summarizer := group messageSummarizers 
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
	summarizer := group messageSummarizers 
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
	summarizer := group messageSummarizers 
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

{ #category : #private }
GtLCodeChangesToolCallsSummarizerExamples >> trackCreatedClassNamed: aClassName [
	createdClasses add: aClassName
]
