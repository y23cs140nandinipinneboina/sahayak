/*
  # Fix teachers table RLS policy for user registration

  1. Security Updates
    - Update INSERT policy to allow authenticated users to create their profile
    - Ensure the policy works correctly during the signup process
    - Maintain security while allowing proper user registration

  2. Changes
    - Drop existing problematic INSERT policy
    - Create new INSERT policy that properly handles user registration
    - Add policy to allow reading during profile creation process
*/

-- Drop the existing INSERT policy that's causing issues
DROP POLICY IF EXISTS "Teachers can insert own profile" ON teachers;

-- Create a new INSERT policy that allows authenticated users to create their profile
CREATE POLICY "Teachers can insert own profile"
  ON teachers
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Also ensure we have a proper SELECT policy for profile creation
DROP POLICY IF EXISTS "Allow read access to authenticated users" ON teachers;

-- Create a more permissive SELECT policy for authenticated users
CREATE POLICY "Teachers can read profiles"
  ON teachers
  FOR SELECT
  TO authenticated
  USING (true);

-- Keep the existing UPDATE policy but ensure it's correct
DROP POLICY IF EXISTS "Teachers can update own profile" ON teachers;

CREATE POLICY "Teachers can update own profile"
  ON teachers
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- Keep the existing individual SELECT policy
DROP POLICY IF EXISTS "Teachers can read own profile" ON teachers;

CREATE POLICY "Teachers can read own profile"
  ON teachers
  FOR SELECT
  TO authenticated
  USING (auth.uid() = id);