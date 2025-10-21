import logo from "@/images/logo.svg"

export default function Home() {
  return (
    <div className="flex min-h-screen items-center justify-center bg-[#fdfdfc] p-6 text-[#706f6c] dark:bg-[#0a0a0a] dark:text-[#a1a09a]">
      <main className="flex flex-col space-y-6">
        <img className="w-full max-w-3xs" src={logo} />
        <div>
          <h1 className="sr-only">Combo</h1>
          <p className="text-xl">
            A web framework, that combines the good parts of modern web development.
          </p>
        </div>
      </main>
    </div>
  )
}
