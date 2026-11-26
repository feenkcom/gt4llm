Class {
	#name : #GtLToolForPreviewRewriteExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#traits : 'TGtLExceptionDomainObjectAssertions',
	#classTraits : 'TGtLExceptionDomainObjectAssertions classTrait',
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #helpers }
GtLToolForPreviewRewriteExamples >> argumentsFrom: aFromString to: aToString className: aClassName packageName: aPackageName [
	^(Dictionary new)
		at: 'from' put: aFromString;
		at: 'to' put: aToString;
		at: 'isMethodPattern' put: false;
		at: 'className' put: aClassName;
		at: 'packageName' put: aPackageName;
		yourself
]

{ #category : #helpers }
GtLToolForPreviewRewriteExamples >> executeRewriteWith: aDictionary [
	^self
		executeTool: GtLToolForPreviewRewrite new
		withArguments: aDictionary
		inContext: (GtLToolExecutionContext new objectStorage: GtLObjectStorage new)
]

{ #category : #helpers }
GtLToolForPreviewRewriteExamples >> fixtureMessageArgumentsClassName: aClassName packageName: aPackageName [
	^self
		argumentsFrom: '`@receiver rewriteFixtureMessage'
		to: '`@receiver rewrittenFixtureMessage'
		className: aClassName
		packageName: aPackageName
]

{ #category : #examples }
GtLToolForPreviewRewriteExamples >> previewRewriteInClass [
	"A rewrite groups its changes; the tool answers a report of the stored preview that lists the rewritten methods with their new sources"

	<gtExample>
	| objectStorage call report targetObject groups aMethodEntry json |
	objectStorage := GtLObjectStorage new.
	call := self
			executeTool: GtLToolForPreviewRewrite new
			withArguments: (self
					fixtureMessageArgumentsClassName: 'GtLRewriteFixture'
					packageName: '')
			inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	report := call result targetObject.
	self assert: report class equals: GtLRefactoringPreviewReport.
	targetObject := self modelOf: call.
	self assert: targetObject class equals: GtLRefactoringPreview.
	self assert: targetObject groupsChanges.
	self assert: targetObject refactoringName equals: 'Rewrite'.
	self assert: (targetObject refactoringDescription beginsWith: 'Rewrite ').
	self
		assert: (targetObject refactoringDescription endsWith: ' in class GtLRewriteFixture').
	self assert: targetObject changes size equals: 1.
	self
		assert: targetObject changes first changeDescription
		equals: 'Add GtLRewriteFixture>>#valueOf:'.	"The formatter output varies (for example '^anObject' or '^ anObject'), so only the rewritten message is checked"
	self
		assert: (targetObject changes first newSource
				includesSubstring: 'rewrittenFixtureMessage').
	self
		assert: (targetObject changes first newSource beginsWith: 'valueOf: anObject').
	groups := report changeGroups.
	self assert: groups methodChanges totalCount equals: 1.
	self assert: groups methodChanges displayedCount equals: 1.
	aMethodEntry := groups methodChanges displayedEntries first.
	self assert: aMethodEntry kind equals: 'modified method'.
	self assert: aMethodEntry methodClassName equals: 'GtLRewriteFixture'.
	self assert: aMethodEntry methodName equals: 'valueOf:'.
	self assert: aMethodEntry classSide not.
	self
		assert: aMethodEntry newSource
		equals: targetObject changes first newSource.
	json := report llmJsonObject.
	self
		assert: json keys asArray
		equals: #('refactoringName' 'refactoringDescription' 'changesCount' 'objectId' 'status' 'methodChanges').
	self
		assert: (((json at: 'methodChanges') at: 'methods') first at: 'newSource')
		equals: aMethodEntry newSource.
	self assert: targetObject isApplied not.
	self assert: (objectStorage objectAt: (json at: 'objectId')) == targetObject.
	self
		assert: ((GtLRewriteFixture >> #valueOf:) sourceCode
				includesSubstring: 'rewriteFixtureMessage').
	^ call
]

{ #category : #examples }
GtLToolForPreviewRewriteExamples >> previewRewriteInClassAndPackage [
	<gtExample>
	| call targetObject |
	call := self
			executeRewriteWith: (self
					fixtureMessageArgumentsClassName: 'GtLRewriteFixture'
					packageName: 'Gt4LlmCore-Examples').
	targetObject := self modelOf: call.
	self assert: targetObject groupsChanges.
	self assert: targetObject changes size equals: 1.
	self
		assert: targetObject changes first changeDescription
		equals: 'Add GtLRewriteFixture>>#valueOf:'.
	^ call
]

{ #category : #examples }
GtLToolForPreviewRewriteExamples >> previewRewriteInPackage [
	"Only the methods of the package are rewritten: a temporary package has the one matching method"

	<gtExample>
	^ self
		withDummyHierarchyDo: [ :aRootClass :aLeafClass | 
			| call targetObject |
			aRootClass
				compile: 'valueOf: anObject ^ anObject rewriteFixtureMessage'
				classified: #examples.
			call := self
					executeRewriteWith: (self
							fixtureMessageArgumentsClassName: ''
							packageName: aRootClass package name asString).
			targetObject := self modelOf: call.
			self assert: targetObject groupsChanges.
			self assert: targetObject changes size equals: 1.
			self
				assert: targetObject changes first changeDescription
				equals: 'Add ' , aRootClass name , '>>#valueOf:'.
			call ]
]

{ #category : #examples }
GtLToolForPreviewRewriteExamples >> previewRewriteWithBlankPattern [
	<gtExample>
	| call |
	call := self
			executeRewriteWith: (self
					argumentsFrom: '   '
					to: '`@receiver rewrittenFixtureMessage'
					className: 'GtLRewriteFixture'
					packageName: '').
	self
		assertMissingArgument: (self modelOf: call)
		withArgumentName: 'from'
		errorMessage: 'Missing argument called from'.
	^ call
]

{ #category : #examples }
GtLToolForPreviewRewriteExamples >> previewRewriteWithBlankScope [
	<gtExample>
	| call |
	call := self
			executeRewriteWith: (self fixtureMessageArgumentsClassName: '   ' packageName: '   ').
	self
		assertMissingArgument: (self modelOf: call)
		withArgumentName: 'className or packageName'
		errorMessage: 'Missing argument called className or packageName'.
	^ call
]

{ #category : #examples }
GtLToolForPreviewRewriteExamples >> previewRewriteWithInvalidPattern [
	<gtExample>
	| call |
	call := self
			executeRewriteWith: (self
					argumentsFrom: '`@receiver foo:'
					to: '`@receiver rewrittenFixtureMessage'
					className: 'GtLRewriteFixture'
					packageName: '').
	self
		assertExceptionDomainObject: (self modelOf: call)
		withExceptionClass: OCCodeError
		messageSubstring: 'Variable or expression expected'.
	^ call
]

{ #category : #examples }
GtLToolForPreviewRewriteExamples >> previewRewriteWithMethodPattern [
	<gtExample>
	| arguments call targetObject |
	arguments := self
			argumentsFrom: 'sizeOf: `arg ^ `arg size'
			to: 'sizeOf: `arg ^ 0'
			className: 'GtLRewriteFixture'
			packageName: ''.
	arguments at: 'isMethodPattern' put: true.
	call := self executeRewriteWith: arguments.
	targetObject := self modelOf: call.
	self assert: targetObject groupsChanges.
	self assert: targetObject changes size equals: 1.
	self
		assert: targetObject changes first changeDescription
		equals: 'Add GtLRewriteFixture>>#sizeOf:'.
	self
		assert: targetObject changes first newSource lines asArray
		equals: #('sizeOf: aCollection' '	^ 0').
	^ call
]

{ #category : #examples }
GtLToolForPreviewRewriteExamples >> previewRewriteWithMissingArguments [
	<gtExample>
	| call |
	call := self executeRewriteWith: Dictionary new.
	self
		assertMissingRequiredProperties: (self modelOf: call)
		withPropertyNames: #('className' 'from' 'isMethodPattern' 'packageName' 'to')
		path: #(nil)
		errorMessage: 'required properties missing [className, from, isMethodPattern, packageName, to]'.
	^ call
]

{ #category : #examples }
GtLToolForPreviewRewriteExamples >> previewRewriteWithUnknownClass [
	<gtExample>
	| call |
	call := self
			executeRewriteWith: (self fixtureMessageArgumentsClassName: 'ClassThatDoesNotExist' packageName: '').
	self
		assertMissingObject: (self modelOf: call)
		withObjectName: 'ClassThatDoesNotExist'
		errorMessage: 'ClassThatDoesNotExist is not found'.
	^ call
]

{ #category : #examples }
GtLToolForPreviewRewriteExamples >> previewRewriteWithUnknownPackage [
	<gtExample>
	| call |
	call := self
			executeRewriteWith: (self
					fixtureMessageArgumentsClassName: ''
					packageName: 'PackageThatDoesNotExist').
	self
		assertMissingObject: (self modelOf: call)
		withObjectName: 'PackageThatDoesNotExist'
		errorMessage: 'PackageThatDoesNotExist is not found'.
	^ call
]

{ #category : #examples }
GtLToolForPreviewRewriteExamples >> previewRewriteWithoutMatches [
	"Without changes, the response still has the methodChanges group, empty"

	<gtExample>
	| call targetObject json |
	call := self
			executeRewriteWith: (self
					argumentsFrom: '`@receiver noSuchFixtureMessage'
					to: '`@receiver rewrittenFixtureMessage'
					className: 'GtLRewriteFixture'
					packageName: '').
	targetObject := self modelOf: call.
	self assert: targetObject groupsChanges.
	self assert: targetObject changes isEmpty.
	self assert: targetObject changesCount equals: 0.
	json := targetObject report llmJsonObject.
	self
		assert: json keys asArray
		equals: #('refactoringName' 'refactoringDescription' 'changesCount' 'objectId' 'status' 'methodChanges').
	self assert: ((json at: 'methodChanges') at: 'totalCount') equals: 0.
	self assert: ((json at: 'methodChanges') at: 'methods') isEmpty.
	^ call
]

{ #category : #examples }
GtLToolForPreviewRewriteExamples >> previewRewriteWithoutObjectStorage [
	<gtExample>
	| call |
	call := self
			executeTool: GtLToolForPreviewRewrite new
			withArguments: (self fixtureMessageArgumentsClassName: 'GtLRewriteFixture' packageName: '').
	self
		assertMissingInformation: (self modelOf: call)
		withModelName: 'objectStorage'
		errorMessage: 'Missing objectStorage'.
	^ call
]

{ #category : #examples }
GtLToolForPreviewRewriteExamples >> previewRewriteWithoutScope [
	<gtExample>
	| call |
	call := self
			executeRewriteWith: (self fixtureMessageArgumentsClassName: '' packageName: '').
	self
		assertMissingArgument: (self modelOf: call)
		withArgumentName: 'className or packageName'
		errorMessage: 'Missing argument called className or packageName'.
	^ call
]
