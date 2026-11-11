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
	<gtExample>
	| objectStorage call targetObject |
	objectStorage := GtLObjectStorage new.
	call := self
			executeTool: GtLToolForPreviewRewrite new
			withArguments: (self
					fixtureMessageArgumentsClassName: 'GtLRewriteFixture'
					packageName: '')
			inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
	targetObject := call result targetObject.
	self assert: targetObject class equals: GtLRefactoringPreview.
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
	self assert: targetObject isApplied not.
	self assert: (objectStorage objectAt: targetObject objectId) == targetObject.
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
	targetObject := call result targetObject.
	self assert: targetObject class equals: GtLRefactoringPreview.
	self assert: targetObject changes size equals: 1.
	self
		assert: targetObject changes first changeDescription
		equals: 'Add GtLRewriteFixture>>#valueOf:'.
	^ call
]

{ #category : #examples }
GtLToolForPreviewRewriteExamples >> previewRewriteInPackage [
	<gtExample>
	| call targetObject |
	call := self
			executeRewriteWith: (self fixtureMessageArgumentsClassName: '' packageName: 'Gt4LlmCore-Examples').
	targetObject := call result targetObject.
	self assert: targetObject class equals: GtLRefactoringPreview.
	self assert: targetObject changes size equals: 1.
	self
		assert: targetObject changes first changeDescription
		equals: 'Add GtLRewriteFixture>>#valueOf:'.
	^ call
]

{ #category : #examples }
GtLToolForPreviewRewriteExamples >> previewRewriteWithBlankPattern [
	<gtExample>
	| call |
	call := self executeRewriteWith: (self
						argumentsFrom: '   '
						to: '`@receiver rewrittenFixtureMessage'
						className: 'GtLRewriteFixture'
						packageName: '').
	self
		assertMissingArgument: call result targetObject
		withArgumentName: 'from'
		errorMessage: 'Missing argument called from'.
	^call
]

{ #category : #examples }
GtLToolForPreviewRewriteExamples >> previewRewriteWithBlankScope [
	<gtExample>
	| call |
	call := self
				executeRewriteWith: (self fixtureMessageArgumentsClassName: '   '
						packageName: '   ').
	self
		assertMissingArgument: call result targetObject
		withArgumentName: 'className or packageName'
		errorMessage: 'Missing argument called className or packageName'.
	^call
]

{ #category : #examples }
GtLToolForPreviewRewriteExamples >> previewRewriteWithInvalidPattern [
	<gtExample>
	| call |
	call := self executeRewriteWith: (self
						argumentsFrom: '`@receiver foo:'
						to: '`@receiver rewrittenFixtureMessage'
						className: 'GtLRewriteFixture'
						packageName: '').
	self
		assertExceptionDomainObject: call result targetObject
		withExceptionClass: OCCodeError
		messageSubstring: 'Variable or expression expected'.
	^call
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
	targetObject := call result targetObject.
	self assert: targetObject class equals: GtLRefactoringPreview.
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
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('className' 'from' 'isMethodPattern' 'packageName' 'to')
		path: #(nil)
		errorMessage: 'required properties missing [className, from, isMethodPattern, packageName, to]'.
	^call
]

{ #category : #examples }
GtLToolForPreviewRewriteExamples >> previewRewriteWithUnknownClass [
	<gtExample>
	| call |
	call := self executeRewriteWith: (self
						fixtureMessageArgumentsClassName: 'ClassThatDoesNotExist'
						packageName: '').
	self
		assertMissingObject: call result targetObject
		withObjectName: 'ClassThatDoesNotExist'
		errorMessage: 'ClassThatDoesNotExist is not found'.
	^call
]

{ #category : #examples }
GtLToolForPreviewRewriteExamples >> previewRewriteWithUnknownPackage [
	<gtExample>
	| call |
	call := self
				executeRewriteWith: (self fixtureMessageArgumentsClassName: ''
						packageName: 'PackageThatDoesNotExist').
	self
		assertMissingObject: call result targetObject
		withObjectName: 'PackageThatDoesNotExist'
		errorMessage: 'PackageThatDoesNotExist is not found'.
	^call
]

{ #category : #examples }
GtLToolForPreviewRewriteExamples >> previewRewriteWithoutMatches [
	<gtExample>
	| call targetObject |
	call := self executeRewriteWith: (self
						argumentsFrom: '`@receiver noSuchFixtureMessage'
						to: '`@receiver rewrittenFixtureMessage'
						className: 'GtLRewriteFixture'
						packageName: '').
	targetObject := call result targetObject.
	self assert: targetObject class equals: GtLRefactoringPreview.
	self assert: targetObject changes isEmpty.
	self assert: targetObject changesCount equals: 0.
	^call
]

{ #category : #examples }
GtLToolForPreviewRewriteExamples >> previewRewriteWithoutObjectStorage [
	<gtExample>
	| call |
	call := self executeTool: GtLToolForPreviewRewrite new
				withArguments: (self fixtureMessageArgumentsClassName: 'GtLRewriteFixture'
						packageName: '').
	self
		assertMissingInformation: call result targetObject
		withModelName: 'objectStorage'
		errorMessage: 'Missing objectStorage'.
	^call
]

{ #category : #examples }
GtLToolForPreviewRewriteExamples >> previewRewriteWithoutScope [
	<gtExample>
	| call |
	call := self
				executeRewriteWith: (self fixtureMessageArgumentsClassName: ''
						packageName: '').
	self
		assertMissingArgument: call result targetObject
		withArgumentName: 'className or packageName'
		errorMessage: 'Missing argument called className or packageName'.
	^call
]
