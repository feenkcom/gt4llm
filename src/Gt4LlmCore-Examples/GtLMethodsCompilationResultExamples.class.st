"
Examples for GtLMethodsCompilationResult domain object.
"
Class {
	#name : #GtLMethodsCompilationResultExamples,
	#superclass : #GtLMagritteDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLMethodsCompilationResultExamples >> methodsCompilationResultCreation [
	<gtExample>
	| resultOne resultTwo result |
	resultOne := GtLMethodCompilationResult new
		oldMethod: nil;
		newMethod: (GtLMethodWithSource new
			methodReference: (GtLMethodReference new
				methodClassName: 'SampleClass';
				methodName: 'methodOne';
				classSide: false;
				yourself);
			sourceCode: 'methodOne ^ 1';
			yourself);
		status: 'compiled';
		yourself.
	resultTwo := GtLMethodCompilationResult new
		oldMethod: (GtLMethodWithSource new
			methodReference: (GtLMethodReference new
				methodClassName: 'SampleClass';
				methodName: 'methodTwo';
				classSide: false;
				yourself);
			sourceCode: 'methodTwo ^ 2';
			yourself);
		newMethod: (GtLMethodWithSource new
			methodReference: (GtLMethodReference new
				methodClassName: 'SampleClass';
				methodName: 'methodTwo';
				classSide: false;
				yourself);
			sourceCode: 'methodTwo ^ 22';
			yourself);
		status: 'compiled';
		yourself.
	result := GtLMethodsCompilationResult new
		methods: { resultOne. resultTwo };
		yourself.
	self assert: result methods size equals: 2.
	self assert: result methods first status equals: 'compiled'.
	self assert: result methods second status equals: 'compiled'.
	^ result
]

{ #category : #examples }
GtLMethodsCompilationResultExamples >> methodsCompilationResultSerialization [
	<gtExample>
	| result jsonObject |
	result := self methodsCompilationResultCreation.
	jsonObject := GtMagritteJSONDataExporter exportObject: result.
	self assert: (jsonObject at: 'methods') size equals: 2.
	self assert: ((jsonObject at: 'methods') first at: 'status') equals: 'compiled'.
	self assert: ((jsonObject at: 'methods') second at: 'status') equals: 'compiled'.
	^ jsonObject
]
