// Supabase client — replace ANON_KEY with your actual anon key
const SUPABASE_URL = 'https://nmemmfblpzrkwyljpmvp.supabase.co';
const SUPABASE_ANON_KEY = 'YOUR_ANON_KEY_HERE';

const { createClient } = supabase;
window.sb = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
