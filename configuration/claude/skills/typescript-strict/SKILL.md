---
name: typescript-strict
description: TypeScript strict mode patterns including schema-first development, branded types, type vs interface guidance, and tsconfig strict flags. Use when writing TypeScript code, defining types or schemas, or reviewing type safety.
---

# TypeScript Strict Mode

## Core Rules

1. **No `any`** - ever. Use `unknown` if type is truly unknown
2. **No type assertions** (`as Type`) without justification
3. **Prefer `type` over `interface`** for data structures
4. **Reserve `interface`** for behavior contracts only

---

## Type vs Interface

### `type` — for data structures

```typescript
export type User = {
  readonly id: string;
  readonly email: string;
  readonly name: string;
  readonly roles: ReadonlyArray<string>;
};
```

**Why `type`?** Better for unions, intersections, mapped types. `readonly` signals immutability. More flexible composition with utility types.

### `interface` — for behavior contracts

```typescript
export interface UserRepository {
  findById(id: string): Promise<User | undefined>;
  save(user: User): Promise<void>;
}
```

**Why `interface`?** Signals "this must be implemented." Works with `implements` keyword. Conventional for dependency injection.

### Schema Duplication

Define schemas once, import everywhere. Never duplicate the same validation logic across multiple files.

```typescript
// ✅ Define once
export const CreateUserRequestSchema = z.object({
  email: z.string().email(),
  name: z.string().min(1),
});
export type CreateUserRequest = z.infer<typeof CreateUserRequestSchema>;

// Import and use wherever needed
```

---

## Strict Mode Configuration

### tsconfig.json Settings

```json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "noUncheckedIndexedAccess": true,
    "exactOptionalPropertyTypes": true,
    "noPropertyAccessFromIndexSignature": true,
    "forceConsistentCasingInFileNames": true,
    "allowUnusedLabels": false
  }
}
```

### What Each Setting Does

**Core strict flags:**

- **`strict: true`** - Enables all strict type checking options
- **`noImplicitAny`** - Error on expressions/declarations with implied `any` type
- **`strictNullChecks`** - `null` and `undefined` have their own types (not assignable to everything)
- **`noUnusedLocals`** - Error on unused local variables
- **`noUnusedParameters`** - Error on unused function parameters
- **`noImplicitReturns`** - Error when not all code paths return a value
- **`noFallthroughCasesInSwitch`** - Error on fallthrough cases in switch statements

**Additional safety flags (CRITICAL):**

- **`noUncheckedIndexedAccess`** - Array/object access returns `T | undefined` (prevents runtime errors from assuming elements exist)
- **`exactOptionalPropertyTypes`** - Distinguishes `property?: T` from `property: T | undefined` (more precise types)
- **`noPropertyAccessFromIndexSignature`** - Requires bracket notation for index signature properties (forces awareness of dynamic access)
- **`forceConsistentCasingInFileNames`** - Prevents case sensitivity issues across operating systems
- **`allowUnusedLabels`** - Error on unused labels (catches accidental labels that do nothing)

### Additional Rules

- **No `@ts-ignore`** without explicit comments explaining why
- **These rules apply to test code as well as production code**

### Architectural Insight: noUnusedParameters Catches Design Issues

The `noUnusedParameters` rule can reveal architectural problems:

**Example**: A function with an unused parameter often indicates the parameter belongs in a different layer. Strict mode catches these design issues early.

---

## Immutability

- Use `readonly` on all `type` properties and `ReadonlyArray<T>` for arrays. The compiler enforces it — leverage this.
- Factory functions (not classes) for object creation, supporting dependency injection.

---

## Schema-First at Trust Boundaries

### When Schemas ARE Required

- Data crosses trust boundary (external → internal)
- Type has validation rules (format, constraints)
- Shared data contract between systems
- Used in test factories (validate test data completeness)

```typescript
// API responses, user input, external data
const UserSchema = z.object({
  id: z.string().uuid(),
  email: z.string().email(),
});
type User = z.infer<typeof UserSchema>;

// Validate at boundary
const user = UserSchema.parse(apiResponse);
```

### When Schemas AREN'T Required

- Pure internal types (utilities, state)
- Result/Option types (no validation needed)
- TypeScript utility types (`Partial<T>`, `Pick<T>`, etc.)
- Behavior contracts (interfaces - structural, not validated)
- Component props (unless from URL/API)

```typescript
// ✅ CORRECT - No schema needed
type Result<T, E> = { success: true; data: T } | { success: false; error: E };

// ✅ CORRECT - Interface, no validation
interface UserService {
  createUser(user: User): Promise<void>;
}
```

---

## Branded Types

For type-safe primitives:

```typescript
type UserId = string & { readonly brand: unique symbol };
type PaymentAmount = number & { readonly brand: unique symbol };

// Type-safe at compile time
const processPayment = (userId: UserId, amount: PaymentAmount) => {
  // Implementation
};

// ❌ Can't pass raw string/number
processPayment("user-123", 100); // Error

// ✅ Must use branded type
const userId = "user-123" as UserId;
const amount = 100 as PaymentAmount;
processPayment(userId, amount); // OK
```
