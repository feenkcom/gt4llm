Class {
	#name : #GtLMethodsWithSourceExamples,
	#superclass : #GtLMagritteDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLMethodsWithSourceExamples >> methodsWithSourceObjectFromCompiledMethods [
	<gtExample>
	| methodObjects methodsWithSourceObject |
	methodObjects := {
		GtLMethodWithSource fromCompiledMethod: (GtLMethodReference class>>#fromCompiledMethod:).
		GtLMethodWithSource fromCompiledMethod: (GtLMethodsWithSource>>#methods:).
	}.
	methodsWithSourceObject := GtLMethodsWithSource new
		methods: methodObjects.

	self
		assert: methodsWithSourceObject methods
		equals: methodObjects.
	self
		assert: methodsWithSourceObject methods size
		equals: 2.

	^ methodsWithSourceObject
]

{ #category : #examples }
GtLMethodsWithSourceExamples >> methodsWithSourceObjectFromCompiledMethodsJsonExport [
	<gtExample>
	| methodsWithSourceObject jsonObject |
	methodsWithSourceObject := self methodsWithSourceObjectFromCompiledMethods.
	jsonObject := GtMagritteJSONDataExporter exportObject: methodsWithSourceObject.

	self
		assert: (jsonObject at: 'methods') size
		equals: 2.
	self
		assert: ((jsonObject at: 'methods') first at: 'methodReference')
		equals: ((NeoJSONObject new)
			at: 'methodName' put: 'fromCompiledMethod:';
			at: 'methodClassName' put: 'GtLMethodReference';
			at: 'classSide' put: true;
			yourself).
	self
		assert: ((jsonObject at: 'methods') second at: 'methodReference')
		equals: ((NeoJSONObject new)
			at: 'methodName' put: 'methods:';
			at: 'methodClassName' put: 'GtLMethodsWithSource';
			at: 'classSide' put: false;
			yourself).

	^ jsonObject
]

{ #category : #examples }
GtLMethodsWithSourceExamples >> methodsWithSourceObjectWithMissingEntries [
	<gtExample>
	| methodObjects methodsWithSourceObject missingObject missingArgument |
	missingObject := GtLMissingDomainObject new
		objectName: 'MissingMethod'.
	missingArgument := GtLMissingArgumentDomainObject new
		arguments: (Dictionary new at: 'methodDescriptors' put: #(); yourself);
		missingArgument: 'methodDescriptors'.
	methodObjects := {
		GtLMethodWithSource fromCompiledMethod: (GtLMethodsWithSource>>#methods:).
		missingObject.
		missingArgument.
	}.
	methodsWithSourceObject := GtLMethodsWithSource new
		methods: methodObjects.

	self
		assert: methodsWithSourceObject methods size
		equals: 3.
	self
		assert: methodsWithSourceObject methods first class
		equals: GtLMethodWithSource.
	self
		assert: methodsWithSourceObject methods second class
		equals: GtLMissingDomainObject.
	self
		assert: methodsWithSourceObject methods third class
		equals: GtLMissingArgumentDomainObject.
	self
		assert: missingObject messageText
		equals: 'MissingMethod is not found'.
	self
		assert: missingArgument messageText
		equals: 'Missing argument called methodDescriptors'.

	^ methodsWithSourceObject
]

{ #category : #examples }
GtLMethodsWithSourceExamples >> methodsWithSourceObjectWithMissingEntriesJsonExport [
	<gtExample>
	| methodsWithSourceObject jsonObject |
	methodsWithSourceObject := self methodsWithSourceObjectWithMissingEntries.
	jsonObject := GtMagritteJSONDataExporter exportObject: methodsWithSourceObject.
	self
		assert: (jsonObject at: 'methods') size
		equals: 3.
	self
		assert: ((jsonObject at: 'methods') first at: 'methodReference')
		equals: ((NeoJSONObject new)
			at: 'methodName' put: 'methods:';
			at: 'methodClassName' put: 'GtLMethodsWithSource';
			at: 'classSide' put: false;
			yourself).
	self
		assert: ((jsonObject at: 'methods') second at: 'missingObjectName')
		equals: 'MissingMethod'.
	self
		assert: ((jsonObject at: 'methods') third at: 'missingArgument')
		equals: 'methodDescriptors'.

	^ jsonObject
]
