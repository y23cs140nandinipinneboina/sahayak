/*
  # Fix teachers table RLS policy

  1. Security Updates
    - Drop existing INSERT policy that may be using incorrect function
    - Create new INSERT policy using proper auth.uid() function
    - Ensure authenticated users can create their own teacher profile

  2. Changes
    - Replace existing INSERT policy with corrected version
    - Use auth.uid() instead of uid() for proper authentication check
*/

-- Drop the existing INSERT policy if it exists
DROP POLICY IF EXISTS "Teachers can insert own profile" ON teachers;

-- Create a new INSERT policy with the correct auth function
CREATE POLICY "Teachers can insert own profile"
  ON teachers
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

-- Ensure the existing policies are still in place
-- (These should already exist based on your schema, but including for completeness)

-- Policy for reading own profile
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE tablename = 'teachers' 
    AND policyname = 'Teachers can read own profile'
  ) THEN
    CREATE POLICY "Teachers can read own profile"
      ON teachers
      FOR SELECT
      TO authenticated
      USING (auth.uid() = id);
  END IF;
END $$;

-- Policy for updating own profile  
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE tablename = 'teachers' 
    AND policyname = 'Teachers can update own profile'
  ) THEN
    CREATE POLICY "Teachers can update own profile"
      ON teachers
      FOR UPDATE
      TO authenticated
      USING (auth.uid() = id);
  END IF;
END $$;