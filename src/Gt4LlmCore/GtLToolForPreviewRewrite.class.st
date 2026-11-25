"
I am the previewRewrite tool: I preview an RBParseTreeRewriter rewrite of the methods of a class and/or a package, store the preview ({{gtClass:GtLRefactoringPreview}}) so that applyRefactoring can apply it, and answer a report of it ({{gtClass:GtLRefactoringPreviewReport}}). A rewrite can change many methods, so its preview groups them; its display options ({{gtClass:GtLRewriteDisplayOptions}}) include the sources by default.
"
Class {
	#name : #GtLToolForPreviewRewrite,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #Gt4LlmCore
}

{ #category : #descriptions }
GtLToolForPreviewRewrite >> classNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Class name';
		accessor: #className;
		comment: 'The class whose instance-side and class-side methods are rewritten, or empty. With packageName too, the methods of both are rewritten.';
		beRequired
]

{ #category : #accessing }
GtLToolForPreviewRewrite >> description [
	^ 'Previews an AST rewrite (search and replace) of the methods of a class, a package or both, without applying it, and stores the preview: pass its objectId to applyRefactoring to apply it. Patterns use the RBParseTreeRewriter syntax: `var matches a variable, `@expr any expression, `#lit a literal and `.stmt a statement.

The response has refactoringName, refactoringDescription, changesCount, objectId, status (not applied) and methodChanges, the rewritten methods, as in previewRefactoring, also when none matches. getRefactoringChanges lists the ones the response does not.

Invalid arguments answer an errorMessage; an error while rewriting, such as a pattern that does not parse, answers an errorReason.

Example JSON arguments:
{"from": "`@receiver foo", "to": "`@receiver bar", "isMethodPattern": false, "className": "MyClass", "packageName": "", "displayOptions": {"methodsLimit": 50}}

Example JSON response:
{"refactoringName": "Rewrite", "refactoringDescription": "Rewrite `@receiver foo → `@receiver bar in class MyClass", "changesCount": 1, "objectId": "abc123", "status": "not applied", "methodChanges": {"totalCount": 1, "displayedCount": 1, "kindCounts": {"modified method": 1}, "methods": [{"kind": "modified method", "methodClassName": "MyClass", "methodName": "baz", "classSide": false, "newSource": "baz ^ self bar"}]}}'
]

{ #category : #descriptions }
GtLToolForPreviewRewrite >> displayOptionsDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		label: 'Display options';
		accessor: #displayOptions;
		classes: {GtLRewriteDisplayOptions};
		beOptional
]

{ #category : #descriptions }
GtLToolForPreviewRewrite >> fromDescription [
	<magritteDescription>
	^(MAStringDescription new)
		label: 'From';
		accessor: #from;
		comment: 'The pattern to search for.';
		beRequired
]

{ #category : #descriptions }
GtLToolForPreviewRewrite >> isMethodPatternDescription [
	<magritteDescription>
	^(MABooleanDescription new)
		label: 'Is method pattern';
		accessor: #isMethodPattern;
		comment: 'True when from and to are whole method patterns.';
		beRequired
]

{ #category : #private }
GtLToolForPreviewRewrite >> methodsIn: aDictionary ifMissing: aBlock [
	| className packageName methods |
	className := (aDictionary at: 'className') trimBoth.
	packageName := (aDictionary at: 'packageName') trimBoth.
	(className isEmpty and: [packageName isEmpty])
		ifTrue: 
			[^aBlock value: ((GtLMissingArgumentDomainObject new)
						arguments: aDictionary;
						missingArgument: 'className or packageName')].
	methods := Set new.
	className ifNotEmpty: 
			[methods addAll: (self methodsOfClassNamed: className
						ifAbsent: [^aBlock value: (GtLMissingDomainObject new objectName: className)])].
	packageName ifNotEmpty: 
			[methods addAll: (self methodsOfPackageNamed: packageName
						ifAbsent: 
							[^aBlock value: (GtLMissingDomainObject new objectName: packageName)])].
	^methods asSortedCollection: [:a :b | a name <= b name]
]

{ #category : #private }
GtLToolForPreviewRewrite >> methodsOfClassNamed: aString ifAbsent: aBlock [
	| class |
	class := Smalltalk globals classNamed: aString.
	class ifNil: [^aBlock value].
	^class localMethods , class classSide localMethods
]

{ #category : #private }
GtLToolForPreviewRewrite >> methodsOfPackageNamed: aString ifAbsent: aBlock [
	^(self packageOrganizer packageNamed: aString ifAbsent: [^aBlock value])
		methods
]

{ #category : #accessing }
GtLToolForPreviewRewrite >> name [
	^'previewRewrite'
]

{ #category : #descriptions }
GtLToolForPreviewRewrite >> packageNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Package name';
		accessor: #packageName;
		comment: 'The package whose methods are rewritten, or empty. With className too, the methods of both are rewritten.';
		beRequired
]

{ #category : #private }
GtLToolForPreviewRewrite >> previewNamespace: aNamespace description: aDescriptionString displayOptions: aDisplayOptions inContext: anExecutionContext [
	"Store the preview and answer a report of it. A rewrite can change many methods: they are listed in a group"

	| preview |
	preview := GtLRefactoringPreview
			namespace: aNamespace
			refactoringName: 'Rewrite'
			refactoringDescription: aDescriptionString
			changeGroupNames: #('methodChanges').
	preview
		objectId: (anExecutionContext objectStorage
				addNewObject: preview
				reason: (GtLStoredObjectStringReason text: 'Rewrite preview')).
	^ preview reportFor: aDisplayOptions
]

{ #category : #private }
GtLToolForPreviewRewrite >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments methods namespace |
	arguments := aToolCall arguments.
	#('from' 'to')
		do: [ :each | 
			(arguments at: each) trimBoth isEmpty
				ifTrue: [ ^ GtLMissingArgumentDomainObject new
						arguments: arguments;
						missingArgument: each ] ].
	anExecutionContext objectStorage
		ifNil: [ ^ GtLMissingInformationDomainObject new missingModelName: 'objectStorage' ].
	methods := self
			methodsIn: arguments
			ifMissing: [ :aDomainObject | ^ aDomainObject ].
	namespace := [ self rewrite: methods with: (self rewriterFor: arguments) ]
			on: Error
			do: [ :anError | 
				^ (GtLExceptionDomainObject freeze: anError)
					errorReason: 'Error while previewing the rewrite';
					yourself ].
	^ self
		previewNamespace: namespace
		description: (self rewriteDescriptionFor: arguments)
		displayOptions: (GtLRewriteDisplayOptions fromArguments: arguments)
		inContext: anExecutionContext
]

{ #category : #private }
GtLToolForPreviewRewrite >> rewrite: aCollection with: aRewriter [
	| namespace |
	namespace := GtRBNamespace new.
	aCollection do: 
			[:each |
			(aRewriter executeTree: each ast copy)
				ifTrue: [(namespace classFor: each methodClass) compileTree: aRewriter tree]].
	^namespace
]

{ #category : #private }
GtLToolForPreviewRewrite >> rewriteDescriptionFor: aDictionary [
	"Return a description of the rewrite, such as 'Rewrite `@receiver foo → `@receiver bar in class MyClass'. The JSON schema requires all these arguments"

	| className packageName scopes |
	className := (aDictionary at: 'className') trimBoth.
	packageName := (aDictionary at: 'packageName') trimBoth.
	scopes := OrderedCollection new.
	className ifNotEmpty: [ scopes add: 'class ' , className ].
	packageName ifNotEmpty: [ scopes add: 'package ' , packageName ].
	^ String
		streamContents: [ :aStream | 
			aStream
				nextPutAll: 'Rewrite ';
				nextPutAll: (aDictionary at: 'from') trimBoth;
				nextPutAll: ' → ';
				nextPutAll: (aDictionary at: 'to') trimBoth.
			scopes
				ifNotEmpty: [ aStream
						nextPutAll: ' in ';
						nextPutAll: (' and ' join: scopes) ].
			(aDictionary at: 'isMethodPattern')
				ifTrue: [ aStream nextPutAll: ' (method pattern)' ] ]
]

{ #category : #private }
GtLToolForPreviewRewrite >> rewriterFor: aDictionary [
	| rewriter |
	rewriter := RBParseTreeRewriter new.
	(aDictionary at: 'isMethodPattern')
		ifTrue: 
			[rewriter replaceMethod: (aDictionary at: 'from')
				with: (aDictionary at: 'to')]
		ifFalse: 
			[rewriter replace: (aDictionary at: 'from') with: (aDictionary at: 'to')].
	^rewriter
]

{ #category : #descriptions }
GtLToolForPreviewRewrite >> toDescription [
	<magritteDescription>
	^(MAStringDescription new)
		label: 'To';
		accessor: #to;
		comment: 'The pattern that replaces each match.';
		beRequired
]
