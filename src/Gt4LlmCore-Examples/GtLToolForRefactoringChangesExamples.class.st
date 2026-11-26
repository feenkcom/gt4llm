"
I show how the getRefactoringChanges tool ({{gtClass:GtLToolForRefactoringChanges}}) lists the changes of a stored preview or result page by page, and how it refuses invalid calls. The previews are never applied.
"
Class {
	#name : #GtLToolForRefactoringChangesExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #support }
GtLToolForRefactoringChangesExamples >> changesOf: anObjectId arguments: aDictionary in: aStorage [
	| arguments |
	arguments := aDictionary copy.
	arguments at: 'objectId' put: anObjectId.
	^ self
		executeTool: GtLToolForRefactoringChanges new
		withArguments: arguments
		inContext: (GtLToolExecutionContext new objectStorage: aStorage)
]

{ #category : #private }
GtLToolForRefactoringChangesExamples >> errorMessageOf: anObjectId groups: aDictionaryOrNil in: aStorage [
	"Return the error message answered when listing the groups of the stored object; without groups when aDictionaryOrNil is nil"

	| arguments |
	arguments := Dictionary new.
	aDictionaryOrNil ifNotNil: [ arguments at: 'groups' put: aDictionaryOrNil ].
	^ (self
		modelOf: (self
				changesOf: anObjectId
				arguments: arguments
				in: aStorage)) errorMessage
]

{ #category : #examples }
GtLToolForRefactoringChangesExamples >> listChangesOfAFlatPreview [
	"A preview whose changes are not grouped is listed whole, whatever the groups"

	<gtExample>
	| storage objectId json |
	storage := GtLObjectStorage new.
	objectId := (self
			modelOf: (self
					executeTool: GtLToolForPreviewRefactoring new
					withArguments: (Dictionary new
							at: 'transformations'
								put: {Dictionary new
											at: 'AddMethod'
												put: (Dictionary new
														at: 'methodClassName' put: self class name asString;
														at: 'classSide' put: false;
														at: 'protocol' put: 'examples';
														at: 'sourceCode' put: 'listedMethod ^ 42';
														yourself);
											yourself};
							yourself)
					inContext: (GtLToolExecutionContext new objectStorage: storage))) objectId.
	json := self
			jsonOf: (self
					changesOf: objectId
					arguments: (Dictionary new
							at: 'includeSources' put: true;
							yourself)
					in: storage).
	self assert: (json at: 'changes') size equals: 1.
	self
		assert: ((json at: 'changes') first at: 'newSource')
		equals: 'listedMethod ^ 42'.
	self assert: (self class includesSelector: #listedMethod) not.
	^ json
]

{ #category : #examples }
GtLToolForRefactoringChangesExamples >> listChangesPageByPage [
	"An agent goes through all the methods of a preview by passing back the nextOffset of the group, until the group has none. Every method is listed once, in the order of the responses"

	<gtExample>
	| storage objectId offset names calls json |
	storage := GtLObjectStorage new.
	objectId := self previewSwappedAssertionsIn: storage.
	offset := 0.
	names := OrderedCollection new.
	calls := 0.
	[ offset notNil ]
		whileTrue: [ json := self
					jsonOf: (self
							changesOf: objectId
							arguments: (Dictionary new
									at: 'groups'
										put: (Dictionary new
												at: 'methodChanges'
													put: (Dictionary new
															at: 'offset' put: offset;
															at: 'limit' put: 3;
															yourself);
												yourself);
									yourself)
							in: storage).
			calls := calls + 1.
			names
				addAll: (((json at: 'methodChanges') at: 'methods')
						collect: [ :each | each at: 'methodName' ]).
			offset := (json at: 'methodChanges') at: 'nextOffset' ifAbsent: [ nil ] ].
	self assert: ((json at: 'methodChanges') at: 'totalCount') > 3.
	self assert: names size equals: ((json at: 'methodChanges') at: 'totalCount').
	self assert: names asSet size equals: names size.
	self assert: calls equals: (names size / 3) ceiling.
	self assert: (json at: 'objectId') equals: objectId.
	self assert: (json at: 'status') equals: 'not applied'.
	^ json
]

{ #category : #examples }
GtLToolForRefactoringChangesExamples >> listChangesWithSourcesFromAnOffset [
	"From an offset, the listed changes start after the skipped ones; with includeSources they have their new source"

	<gtExample>
	| storage objectId json methods |
	storage := GtLObjectStorage new.
	objectId := self previewSwappedAssertionsIn: storage.
	json := self
			jsonOf: (self
					changesOf: objectId
					arguments: (Dictionary new
							at: 'includeSources' put: true;
							at: 'groups'
								put: (Dictionary new
										at: 'methodChanges'
											put: (Dictionary new
													at: 'offset' put: 1;
													at: 'limit' put: 2;
													yourself);
										yourself);
							yourself)
					in: storage).
	self assert: ((json at: 'methodChanges') at: 'offset') equals: 1.
	self assert: ((json at: 'methodChanges') at: 'displayedCount') equals: 2.
	self assert: ((json at: 'methodChanges') at: 'nextOffset') equals: 3.
	methods := (json at: 'methodChanges') at: 'methods'.
	self assert: (methods allSatisfy: [ :each | each includesKey: 'newSource' ]).
	^ json
]

{ #category : #support }
GtLToolForRefactoringChangesExamples >> previewSwappedAssertionsIn: aStorage [
	"A rewrite preview that changes many methods of my class; it is never applied"

	| call |
	call := self
			executeTool: GtLToolForPreviewRewrite new
			withArguments: (Dictionary new
					at: 'from' put: '`@receiver assert: `@actual equals: `@expected';
					at: 'to' put: '`@receiver assert: `@expected equals: `@actual';
					at: 'isMethodPattern' put: false;
					at: 'className' put: GtLRefactoringReportExamples name asString;
					at: 'packageName' put: '';
					yourself)
			inContext: (GtLToolExecutionContext new objectStorage: aStorage).
	^ (self modelOf: call) objectId
]

{ #category : #examples }
GtLToolForRefactoringChangesExamples >> refuseInvalidCalls [
	"Unknown ids, objects that are not refactorings, missing groups and groups the refactoring does not have are refused by the tool; the JSON schema refuses invalid offsets before the tool runs"

	<gtExample>
	| storage objectId otherId |
	storage := GtLObjectStorage new.
	objectId := self previewSwappedAssertionsIn: storage.
	otherId := storage addNewObject: Object new reasonString: 'not a refactoring'.
	self
		assert: (self
				errorMessageOf: 'unknown-id'
				groups: nil
				in: storage)
		equals: 'unknown-id is not found'.
	self
		assert: (self
				errorMessageOf: otherId
				groups: nil
				in: storage)
		equals: otherId , ' is not a refactoring preview or result'.
	self
		assert: (self
				errorMessageOf: objectId
				groups: nil
				in: storage)
		equals: 'groups must name at least one group, such as methodChanges'.
	self
		assert: (self
				errorMessageOf: objectId
				groups: {'classChanges' -> Dictionary new} asDictionary
				in: storage)
		equals: objectId , ' has no classChanges; its groups are methodChanges'.
	self
		assert: (self
				errorMessageOf: objectId
				groups: {'methodChanges' -> {'offset' -> 1.5} asDictionary} asDictionary
				in: storage)
		equals: '@[groups/methodChanges/offset] integer expected'.
	^ storage
]

{ #category : #examples }
GtLToolForRefactoringChangesExamples >> refuseLepiterChangesOfARewriteResult [
	"A rewrite result has no Lepiter changes: the refusal names its groups, and does not mistake it for a failed apply, after which the Lepiter changes are not known"

	<gtExample>
	^ self
		withDummyHierarchyDo: [ :aRootClass :aLeafClass | 
			| storage context previewCall applyCall resultId |
			aRootClass
				compile: 'valueOf: anObject ^ anObject rewriteFixtureMessage'
				classified: #examples.
			storage := GtLObjectStorage new.
			context := GtLToolExecutionContext new objectStorage: storage.
			previewCall := self
					executeTool: GtLToolForPreviewRewrite new
					withArguments: (Dictionary new
							at: 'from' put: '`@receiver rewriteFixtureMessage';
							at: 'to' put: '`@receiver rewrittenFixtureMessage';
							at: 'isMethodPattern' put: false;
							at: 'className' put: aRootClass name asString;
							at: 'packageName' put: '';
							yourself)
					inContext: context.
			applyCall := self
					executeTool: GtLToolForApplyRefactoring new
					withArguments: {'objectId' -> (self modelOf: previewCall) objectId}
							asDictionary
					inContext: context.
			resultId := (self modelOf: applyCall) objectId.
			self assert: (self modelOf: applyCall) status equals: 'applied'.
			self
				assert: (self
						errorMessageOf: resultId
						groups: {'lepiterChanges' -> Dictionary new} asDictionary
						in: storage)
				equals: resultId , ' has no lepiterChanges; its groups are methodChanges'.
			storage ]
]
