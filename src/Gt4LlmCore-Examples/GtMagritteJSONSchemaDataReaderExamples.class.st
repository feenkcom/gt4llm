Class {
	#name : #GtMagritteJSONSchemaDataReaderExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #expecting }
GtMagritteJSONSchemaDataReaderExamples >> expectedMathReasoningDelegatedTypesTypeStep [
	^ GtLDemoMathReasoningWithDelegatedSteps new
		finalAnswer: 'The solution to the equation 8x + 7 = -23 is x = -15/4.';
  	steps: {
  		GtLDemoMathReasoningDelegatedStep new 
  			step: (GtLDemoMathReasoningExplanationStep  new
    			content: 'Start by isolating the term with x: subtract 7 from both sides, giving 8x = -30.').
    		
    	GtLDemoMathReasoningDelegatedStep new 
  			step: (GtLDemoMathReasoningExplanationStep  new
    			content: 'Next, divide both sides by 8 to solve for x. This yields x = -30/8.').
      
      GtLDemoMathReasoningDelegatedStep new 
  			step:(GtLDemoMathReasoningExplanationStep  new
    			content: 'Simplify the fraction by dividing numerator and denominator by 2: x = -15/4.').
    	
    	GtLDemoMathReasoningDelegatedStep new 
  			step:(GtLDemoMathReasoningOutputStep  new
      		output: 'x = -15/4').
	}
]

{ #category : #expecting }
GtMagritteJSONSchemaDataReaderExamples >> expectedMathReasoningMultipleTypesTypeStep [
	^ GtLDemoMathReasoningWithDifferentSteps new
		finalAnswer: 'x = -15/4';
  	steps: {
    	GtLDemoMathReasoningExplanationStep  new
    		content: 'We are given the equation 8x + 7 = -23. The goal is to isolate x.'.
    		
    	GtLDemoMathReasoningExplanationStep  new
    		content: 'Subtract 7 from both sides to eliminate the constant on the left side, resulting in 8x + 7 - 7 = -23 - 7.'.
      
      GtLDemoMathReasoningOutputStep  new
      	output: '8x = -30'.
      
      GtLDemoMathReasoningExplanationStep  new
    		content: 'Divide both sides by 8 to solve for x.'.
    	
    	GtLDemoMathReasoningOutputStep  new
      	output: 'x = -30/8'.
 
       GtLDemoMathReasoningExplanationStep  new
    		content: 'Simplify the fraction by dividing numerator and denominator by 2.'.
    	
    	GtLDemoMathReasoningOutputStep  new
      	output: 'x = -15/4'.
      	
	}
]

{ #category : #expecting }
GtMagritteJSONSchemaDataReaderExamples >> expectedMathReasoningWithSingleTypeStep [
	^ GtLDemoMathReasoning new
		finalAnswer: 'x = -15 / 4';
  	steps: {
    	GtLDemoMathReasoningStep  new
    		explanation: 'Start with the equation 8x + 7 = -23.';
      	output: '8x + 7 = -23'.
      
      GtLDemoMathReasoningStep  new
    		explanation: 'Subtract 7 from both sides to isolate the term with the variable.';
      	output: '8x = -23 - 7'.
      	
      GtLDemoMathReasoningStep  new
    		explanation: 'Simplify the right side of the equation.';
      	output: '8x = -30'.
      	
      GtLDemoMathReasoningStep  new
    		explanation: 'Divide both sides by 8 to solve for x.';
      	output: 'x = -30 / 8'.
      	
      GtLDemoMathReasoningStep  new
    		explanation: 'Simplify the fraction.';
      	output: 'x = -15 / 4'.
      }
]

{ #category : #accessing }
GtMagritteJSONSchemaDataReaderExamples >> mathReasoningWithDelegatedTypeStepData [
	^ '{
	"finalAnswer" : "The solution to the equation 8x + 7 = -23 is x = -15/4.",
	"steps" : [
		{
			"step" : {
				"content" : "Start by isolating the term with x: subtract 7 from both sides, giving 8x = -30."
			}
		},
		{
			"step" : {
				"content" : "Next, divide both sides by 8 to solve for x. This yields x = -30/8."
			}
		},
		{
			"step" : {
				"content" : "Simplify the fraction by dividing numerator and denominator by 2: x = -15/4."
			}
		},
		{
			"step" : {
				"output" : "x = -15/4"
			}
		}
	]
}'
]

{ #category : #accessing }
GtMagritteJSONSchemaDataReaderExamples >> mathReasoningWithDelegatedTypeStepReader [
	^ GtMagritteJSONSchemaDataReader 
			forModelClass: GtLDemoMathReasoningWithDelegatedSteps
]

{ #category : #accessing }
GtMagritteJSONSchemaDataReaderExamples >> mathReasoningWithMultipleTypesStepData [
	^ '{
	"finalAnswer" : "x = -15/4",
	"steps" : [
		{
			"content" : "We are given the equation 8x + 7 = -23. The goal is to isolate x."
		},
		{
			"content" : "Subtract 7 from both sides to eliminate the constant on the left side, resulting in 8x + 7 - 7 = -23 - 7."
		},
		{
			"output" : "8x = -30"
		},
		{
			"content" : "Divide both sides by 8 to solve for x."
		},
		{
			"output" : "x = -30/8"
		},
		{
			"content" : "Simplify the fraction by dividing numerator and denominator by 2."
		},
		{
			"output" : "x = -15/4"
		}
	]
}'
]

{ #category : #accessing }
GtMagritteJSONSchemaDataReaderExamples >> mathReasoningWithMultipleTypesStepReader [
	^ GtMagritteJSONSchemaDataReader 
			forModelClass: GtLDemoMathReasoningWithDifferentSteps
]

{ #category : #accessing }
GtMagritteJSONSchemaDataReaderExamples >> mathReasoningWithSingleTypeStepData [
	^ '{
  "steps": [
    {
      "explanation": "Start with the equation 8x + 7 = -23.",
      "output": "8x + 7 = -23"
    },
    {
      "explanation": "Subtract 7 from both sides to isolate the term with the variable.",
      "output": "8x = -23 - 7"
    },
    {
      "explanation": "Simplify the right side of the equation.",
      "output": "8x = -30"
    },
    {
      "explanation": "Divide both sides by 8 to solve for x.",
      "output": "x = -30 / 8"
    },
    {
      "explanation": "Simplify the fraction.",
      "output": "x = -15 / 4"
    }
  ],
  "finalAnswer": "x = -15 / 4"
}'
]

{ #category : #accessing }
GtMagritteJSONSchemaDataReaderExamples >> mathReasoningWithSingleTypeStepReader [
	^ GtMagritteJSONSchemaDataReader 
			forModelClass: GtLDemoMathReasoning
]

{ #category : #examples }
GtMagritteJSONSchemaDataReaderExamples >> readMathReasoningWithDelegatedType [
	<gtExample>
	| dataReader mathReasoning |
	dataReader := self mathReasoningWithDelegatedTypeStepReader.
	mathReasoning := dataReader 
		readFrom: self mathReasoningWithDelegatedTypeStepData readStream.
		
	self 
		assert: mathReasoning 
		equals:self expectedMathReasoningDelegatedTypesTypeStep.
		
	^ mathReasoning
]

{ #category : #examples }
GtMagritteJSONSchemaDataReaderExamples >> readMathReasoningWithMultipleTypes [
	<gtExample>
	| dataReader mathReasoning |
	dataReader := self mathReasoningWithMultipleTypesStepReader.
	mathReasoning := dataReader 
		readFrom: self mathReasoningWithMultipleTypesStepData readStream.
		
	self 
		assert: mathReasoning 
		equals:self expectedMathReasoningMultipleTypesTypeStep.
		
	^ mathReasoning
]

{ #category : #examples }
GtMagritteJSONSchemaDataReaderExamples >> readMathReasoningWithSingleType [
	<gtExample>
	| dataReader mathReasoning |
	dataReader := self mathReasoningWithSingleTypeStepReader.
	mathReasoning := dataReader 
		readFrom: self mathReasoningWithSingleTypeStepData readStream.
		
	self 
		assert: mathReasoning 
		equals:self expectedMathReasoningWithSingleTypeStep.
		
	^ mathReasoning
]
